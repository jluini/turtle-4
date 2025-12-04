extends CanvasLayer

@export var player_hud_model: PackedScene
@export var player_hud_container: NodePath

func _on_network_state_changed(new_state: Lobby.State):
	match new_state:
		Lobby.State.HOSTING:
			$menu.switch_to("lobby")
		Lobby.State.CONNECTING:
			$menu.switch_to("connecting")
		Lobby.State.CONNECTED:
			$menu.switch_to("lobby")


func _on_add_player_button_pressed() -> void:
	var entered_name: String = %new_player_name.text
	if entered_name.is_empty():
		return
	
	print("You entered '%s'" % [entered_name])
