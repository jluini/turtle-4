extends Label

func _on_network_state_changed(new_state: Lobby.State):
	text = Lobby.State.find_key(new_state)
