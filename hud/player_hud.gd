extends HBoxContainer

@onready var hud = find_parent("lobby")

var local: bool:
	set(new_local):
		local = new_local
		$button.visible = local

var player: PlayerInfo:
	set(new_player):
		player = new_player
		_update_view()

func _update_view():
	$id_label.text = "#{player_id}".format({"player_id": player.player_id})
	$name_label.text = player.name

func _on_button_pressed() -> void:
	print("team change (%s)" % [$name_label.text])
	#hud.lobby.change_team(player)
	change_team.rpc_id(1, player.to_dict())

@rpc("authority", "call_local", "reliable")
func change_team(player):
	print("%s: change player %s" % [multiplayer.get_unique_id(), player])
	hud.change_team(PlayerInfo.from_dict(player))
