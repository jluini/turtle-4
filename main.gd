extends Node2D

func _ready() -> void:
	$lobby.local_peer_info.peer_name = 'La vida loca'
	print($lobby.local_peer_info.players.size())
