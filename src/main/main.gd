extends Node3D

const PlayerState = preload("res://src/enums/player_state.gd")

@onready var player := $Player
@onready var playerStateLabel := $Control/PlayerState
@onready var fps_info := $Control/FpsInfo

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	match player.state:
		PlayerState.Idle:
			playerStateLabel.text = "Idle"
		PlayerState.Walking:
			playerStateLabel.text = "Walking"
		PlayerState.Running:
			playerStateLabel.text = "Running"
		PlayerState.Jumping:
			playerStateLabel.text = "Jumping"
	fps_info.text = str(Engine.get_frames_per_second()) + " fps"
