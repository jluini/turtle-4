@tool
extends Node

@export var initial_view: String:
	set(new_initial_view):
		initial_view = new_initial_view
		_update()

func _update():
	if initial_view:
		switch_to(initial_view)
	else:
		switch_to_first()

func _ready() -> void:
	_update()

func switch_to_first():
	var first_child = true
	for child:Node in get_children():
		child.visible = first_child
		first_child = false

func switch_to(node_name:String):
	for child:Node in get_children():
		child.visible = child.name == str(node_name)
