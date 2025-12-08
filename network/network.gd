class_name Network
extends Node

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

var state: State = State.NOTHING:
	set(new_state):
		state = new_state
		emit_signal("state_changed", new_state)

func _ready() -> void:
	state = State.INITIAL
	_connect_network_callbacks()

### Initiate networking

func create_server() -> int:
	if state != State.INITIAL:
		return ERR_UNAVAILABLE
	
	var new_peer = ENetMultiplayerPeer.new()
	var error = new_peer.create_server(PORT, MAX_CONNECTIONS)
	
	if error:
		return error

	multiplayer.multiplayer_peer = new_peer
	state = State.HOSTING

	return OK

func connect_as_client() -> int:
	if state != State.INITIAL:
		return ERR_UNAVAILABLE
	
	var new_peer = ENetMultiplayerPeer.new()
	var error = new_peer.create_client(DEFAULT_SERVER_IP, PORT)
	
	if error:
		return error
	
	multiplayer.multiplayer_peer = new_peer
	state = State.CONNECTING
	
	return OK

### Network callbacks

func _on_peer_connected(id):
	print("%s: peer_connected %s" % [multiplayer.get_unique_id(), id])

func _on_peer_disconnected(id):
	print("%s: peer_disconnected %s" % [multiplayer.get_unique_id(), id])

func _on_connected_to_server():
	print("%s: connected_to_server" % [multiplayer.get_unique_id()])
	if state != State.CONNECTING:
		# TODO: should force disconnection here
		print("%s: unexpected connected_to_server; ignoring" % [multiplayer.get_unique_id()])
		return
	
	state = State.CONNECTED

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
