extends Node2D

@onready var network: Lobby = $network

func _ready() -> void:
	#$network.local_peer_info.peer_name = 'La vida loca'
	#print($network.local_peer_info.players.size())
	pass

func add_player(new_player_name: String) -> void:
	#pass
	#print("coso: %s" % [new_player_name])
	
	if [Lobby.State.HOSTING, Lobby.State.CONNECTED].has(network.state):
		pass
		_add_player.rpc_id(1, new_player_name)

@rpc("any_peer", "reliable")
func _add_player(new_player_name: String) -> void:
	pass
	#var new_player = Turtle
		
