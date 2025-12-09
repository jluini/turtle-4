class_name LobbyInfo2
extends Node

@export var scenario: Scenario
#@export var players: Array[PlayerInfo] = []
@export var players: Array = []

### Debugging

func display_name() -> String:
	return "%s with players %s" % [scenario.name, str(players)]

### RPC serialization

func to_dict():
	return {
		"scenario": scenario.to_dict(),
		"players": players.map(func(p): return p.to_dict())
	}

static func from_dict(serialized: Dictionary) -> LobbyInfo2:
	var out = new()
	
	out.scenario = Scenario.from_dict(serialized["scenario"])
	print(serialized["players"])
	print(serialized["players"].map(func(p): return PlayerInfo.from_dict(p)))
	out.players = serialized["players"].map(func(p): return PlayerInfo.from_dict(p))

	return out
