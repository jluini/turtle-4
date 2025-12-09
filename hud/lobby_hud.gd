extends Control

func _ready() -> void:
	$v_box_container/player_list.get_child(0).visible = false

func _on_lobby_scenario_changed(new_scenario: Scenario) -> void:
	$v_box_container/scenario/scenario_name.text = new_scenario.name

func _on_lobby_player_added(new_player: PlayerInfo) -> void:
	var new_player_hud = $v_box_container/player_list.get_child(0).duplicate()
	new_player_hud.local = new_player.peer_id == multiplayer.get_unique_id()
	new_player_hud.player = new_player
	new_player_hud.show()
			
	$v_box_container/player_list.add_child(new_player_hud)

func change_team(player):
	print("%s: change team %s" % [multiplayer.get_unique_id(), player.display_name()])
