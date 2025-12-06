extends Control

@export var data: TurtlePeerInfo

func set_data(peer_info: TurtlePeerInfo):
	data = peer_info
	$name_label.text = peer_info.peer_name
	$id_label.text = str(peer_info.peer_id)
