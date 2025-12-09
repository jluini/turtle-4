extends Control

func _ready() -> void:
	$menu/initial/text_edit.text = Samples.new().sample_player_name()

func _on_create_server_button_pressed() -> void:
	%network.create_server()

func _on_connect_button_pressed() -> void:
	%network.connect_as_client()

func _on_network_state_changed(new_state: String) -> void:
	match new_state:
		"HOSTING":
			$menu.switch_to("lobby")
		"CONNECTING":
			$menu.switch_to("connecting")
		"CONNECTED":
			$menu.switch_to("lobby")
