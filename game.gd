class_name Game
extends Node2D

var camera_dir: Vector2

func _ready() -> void:
	get_window().position.y = 0

func _process(delta: float) -> void:
	$offset/camera.position += camera_dir * delta * 100.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$ui.visible = not $ui.visible
	elif event.is_action_pressed("ui_cancel"):
		$offset/camera.position = Vector2.ZERO
	
	if true: # event.action is_action("ui_left") or event.is_action("ui_right"):
		camera_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
