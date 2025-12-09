class_name OldGame
extends Node2D

signal state_changed(new_state: State)
signal peer_added(new_peer: PeerInfo)
signal peer_activated(peer: PeerInfo)

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

enum State {
	NOTHING,
	INITIAL,
	HOSTING,
	CONNECTING,
	CONNECTED,
	PLAYING,
	SPECTATOR
}

### Config

@export var lobby_info_class = LobbyInfo
@export var peer_info_class = PeerInfo

### 

@export var lobby_info: LobbyInfo
@export var local_peer_info: PeerInfo

@export var game: Node

###

var state: State = State.NOTHING:
	set(new_state):
		state = new_state
		%state_label.text = State.find_key(new_state)
		emit_signal("state_changed", new_state)

func _ready() -> void:
	state = State.INITIAL
	_connect_network_callbacks()
	
	# TODO: abstraer turtle
	local_peer_info = TurtlePeerInfo.new()
	local_peer_info.peer_name = Samples.new().sample_node_name()
	local_peer_info.peer_id = 0
	
	add_peer(local_peer_info)

####

func create_server() -> int:
	if state != State.INITIAL:
		return ERR_UNAVAILABLE
	
	var new_peer = ENetMultiplayerPeer.new()
	var error = new_peer.create_server(PORT, MAX_CONNECTIONS)
	
	if error:
		return error
	
	multiplayer.multiplayer_peer = new_peer
	state = State.HOSTING
	activate_peer(1)
	
	return OK

func create_client() -> int:
	if state != State.INITIAL:
		return FAILED
	
	var new_peer = ENetMultiplayerPeer.new()
	var error = new_peer.create_client(DEFAULT_SERVER_IP, PORT)
	
	if error:
		return error
	
	multiplayer.multiplayer_peer = new_peer
	state = State.CONNECTING
	
	return OK

# TODO: prepend underscore if it's private
func add_peer(peer_info):
	lobby_info.peers.append(peer_info)
	emit_signal("peer_added", peer_info)

# TODO: prepend underscore if it's private
func activate_peer(new_peer_id: int):
	assert(lobby_info.peers.size() == 1)
	var old_peer_id = lobby_info.peers[0].peer_id
	
	assert(old_peer_id == 0) # TODO: pedir demasiado?
	
	lobby_info.peers[0].peer_id = new_peer_id
	emit_signal("peer_activated", lobby_info.peers[0])

### RPCs

@rpc("authority", "reliable")
func you_are_welcome(serialized_lobby_info):
	lobby_info = lobby_info_class.deserialize(serialized_lobby_info)
	
	for peer_info in lobby_info.peers:
		emit_signal("peer_added", peer_info)
	
	this_is_my_initial_peer_info.rpc_id(1, local_peer_info.serialize())

@rpc("any_peer", "reliable")
func this_is_my_initial_peer_info(serialized_peer_info):
	if state != State.HOSTING:
		print("late reception of %s from %s: %s" % [get_stack()[0]["function"], multiplayer.get_remote_sender_id(), serialized_peer_info])
		return
	
	# TODO: should check peer_id is right before broadcasting it
	
	peer_added_to_lobby.rpc(serialized_peer_info)

@rpc("authority", "call_local", "reliable")
func peer_added_to_lobby(serialized_peer_info):
	var peer_info = peer_info_class.deserialize(serialized_peer_info)

	if peer_info.peer_id == multiplayer.get_unique_id():
		# this is me; ignoring
		return
	else:
		add_peer(peer_info)

### Network callbacks

func _on_peer_connected(id):
	#print("%s: peer_connected %s" % [multiplayer.get_unique_id(), id])
	
	if id == 1:
		pass #print("%s: connected 2" % [multiplayer.get_unique_id()])
	elif multiplayer.is_server():
		match state:
			State.HOSTING:
				# player is welcome to lobby
				you_are_welcome.rpc_id(id, lobby_info.serialize())

			State.PLAYING:
				# player is welcome as spectator ?
				pass # TODO

func _on_peer_disconnected(id):
	print("%s: peer_disconnected %s" % [multiplayer.get_unique_id(), id])

func _on_connected_to_server():
	# print("%s: connected_to_server" % [multiplayer.get_unique_id()])
	if state != State.CONNECTING:
		print("%s: unexpected connected_to_server; ignoring" % [multiplayer.get_unique_id()])
		return
	
	state = State.CONNECTED
	activate_peer(multiplayer.get_unique_id())

func _on_connection_failed():
	print("%s: connection_failed" % [multiplayer.get_unique_id()])

func _on_server_disconnected():
	print("server_disconnected")

### Private misc

func _connect_network_callbacks() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
