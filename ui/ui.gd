extends CanvasLayer

@export var player_hud_model: PackedScene
@export var player_hud_container: NodePath

### Network signals

func _on_network_state_changed(new_state: Lobby.State):
	match new_state:
		Lobby.State.HOSTING:
			$menu.switch_to("lobby")
		Lobby.State.CONNECTING:
			$menu.switch_to("connecting")
		Lobby.State.CONNECTED:
			$menu.switch_to("lobby")

func _on_network_peer_added(new_peer: PeerInfo) -> void:
	pass # Replace with function body.
	var peer_scene = preload("res://network/peer_item.tscn")
	var new_peer_item = peer_scene.instantiate()
	new_peer_item.set_data(new_peer)
	$peer_list_container/peer_list.add_child(new_peer_item)

func _on_network_peer_activated(peer: PeerInfo) -> void:
	_find_peer(peer).set_data(peer)

###

func _find_peer(peer: PeerInfo) -> Node:
	for c in $peer_list_container/peer_list.get_children():
		if c.data == peer:
			return c
	
	return null

### UI Callbacks

func _on_add_player_button_pressed() -> void:
	var entered_name: String = %new_player_name.text
	if entered_name.is_empty():
		return
	
	get_parent().add_player(entered_name)
