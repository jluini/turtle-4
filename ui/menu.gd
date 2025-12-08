extends Node

func _ready() -> void:
	var first_child = true
	for child:Node in get_children():
		child.visible = first_child
		first_child = false
	

func switch_to(node_name:String):
	for child:Node in get_children():
		child.visible = child.name == str(node_name)
