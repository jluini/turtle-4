class_name TurtleLobbyInfo
extends LobbyInfo

@export var map_name: String

### Debugging

func display_name() -> String:
	return "map: {map_name}".format(serialize())

### RPC serialization

func serialize():
	return {
		"map_name": map_name,
		"peers": peers.map(func(peer): return peer.serialize())
	}

static func deserialize(serialized: Dictionary) -> TurtleLobbyInfo:
	var out = new()
	
	out.map_name = serialized["map_name"]
	out.peers = serialized["peers"].map(func(sp): return TurtlePeerInfo.deserialize(sp))
	
	return out
