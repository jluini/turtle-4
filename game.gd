class_name Game
extends Node2D

signal state_changed(new_state: String)

enum State {
	NOTHING,
	INITIAL,
	LOBBY
}

var state: State = State.NOTHING:
	set(new_state):
		state = new_state
		emit_signal("state_changed", State.find_key(new_state))

var camera_dir: Vector2

func _ready() -> void:
	state = State.INITIAL
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

### Start game

func play_versus():
	pass # state != Network.State.INITIAL:
	#	return ERR_UNAVAILABLE

func create_server(player_name: String):
	if state != State.INITIAL:
		return ERR_UNAVAILABLE
	
	var err = %network.create_server()
	
	if err:
		return err
	
	state = State.LOBBY
	
	# _clear_player_data()
	_add_player(player_name, 1)

func connect_as_client(player_name: String):
	if state != State.INITIAL:
		return ERR_UNAVAILABLE
	
	var err = %network.connect_as_client()
	if err:
		return err
	
	# _clear_player_data()
	# state = 

func _add_player(player_name: String, team_number: int):
	var new_player = PlayerInfo.neww(player_name, team_number)
	$lobby.add_player(new_player)

###

func set_lobby_info(serialized_lobby_info):
	var lobby_info = LobbyInfo2.from_dict(serialized_lobby_info)
	$lobby.lobby_info = lobby_info
	
func get_lobby_info():
	return $lobby.lobby_info.to_dict()


func _on_network_state_changed(new_state: String) -> void:
	match new_state:
		"CONNECTED":
			state = State.LOBBY
