extends Node

@onready var game: Game = find_parent("game")

func _ready() -> void:
	$menu/initial/v_box_container/line_edit.text = Samples.new().sample_player_name()

func _on_game_state_changed(new_state: String):
	match new_state:
		"LOBBY":
			$menu.switch_to("lobby")

func _on_play_versus_button_pressed() -> void:
	game.play_versus()

func _on_create_server_button_pressed() -> void:
	game.create_server($menu/initial/v_box_container/line_edit.text)

func _on_connect_button_pressed() -> void:
	game.connect_as_client($menu/initial/v_box_container/line_edit.text)
