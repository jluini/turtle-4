class_name Scenario
extends Resource

@export var name: String
@export var min_players: int = 2
@export var max_players: int = 2

@export var scene: PackedScene

### Debugging

func display_name() -> String:
	return "{name}".format(to_dict())

### RPC serialization

func to_dict():
	return {
		"name": name,
		"min_players": min_players,
		"max_players": max_players,
		"scene": scene.resource_path,
	}

static func from_dict(serialized: Dictionary) -> Scenario:
	var out = new()
	
	out.name = serialized["name"]
	out.min_players = serialized["min_players"]
	out.max_players = serialized["max_players"]
	out.scene = load(serialized["scene"])

	return out
