class_name PlayerInfo
extends Resource

@export var peer_id: int = 0
@export var player_id: int = 0

@export var name: String
@export var team: int = 0

static func neww(name, team) -> PlayerInfo:
	var out = new()
	out.name = name
	out.team = team
	return out

### Debugging

func display_name() -> String:
	return "{peer_id}:{player_id}:{name}:{team}".format(to_dict())

### RPC serialization

func to_dict():
	return {
		"peer_id": peer_id,
		"player_id": player_id,
		"name": name,
		"team": team
	}

static func from_dict(serialized: Dictionary) -> PlayerInfo:
	var out = new()
	
	out.peer_id = serialized["peer_id"]
	out.player_id = serialized["player_id"]
	out.name = serialized["name"]
	out.team = serialized["team"]

	return out
