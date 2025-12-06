class_name TurtlePeerInfo
extends PeerInfo

@export var peer_name: String
@export var players: Array = []

### Debugging

func display_name() -> String:
	return "{peer_id}:{peer_name}".format(serialize())

### RPC serialization

func serialize():
	return {
		"peer_id": peer_id,
		"peer_name": peer_name
	}

static func deserialize(serialized: Dictionary) -> TurtlePeerInfo:
	var out = new()
	
	out.peer_id = serialized["peer_id"]
	out.peer_name = serialized["peer_name"]
	
	return out
