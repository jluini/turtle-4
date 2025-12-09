class_name Lobby
extends Node

signal scenario_changed(new_scenario: Scenario)
signal player_added(new_player: PlayerInfo)

@export var scenario: Scenario:
	set(new_scenario):
		scenario = new_scenario
		lobby_info.scenario = new_scenario
		emit_signal("scenario_changed", new_scenario)

@export var lobby_info: LobbyInfo2 = LobbyInfo2.new():
	set(new_lobby_info):
		print("%s: setting lobby info '%s'" % [multiplayer.get_unique_id(), new_lobby_info.to_dict()])
		lobby_info = new_lobby_info
		emit_signal("scenario_changed", lobby_info.scenario)
		
		for p in lobby_info.players:
			emit_signal("player_added", p)
		

var local_players: Array[PlayerInfo] = []

func _ready():
	scenario = scenario # just to trigger the signal 'scenario_changed'

func add_player(new_player: PlayerInfo):
	new_player.peer_id = multiplayer.get_unique_id()
	new_player.player_id = local_players.size() + 1
	local_players.append(new_player)
	lobby_info.players.append(new_player)
	emit_signal("player_added", new_player)

#func lobby_info():
	#return lobby_info
