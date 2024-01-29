extends Node3D

const PlayerState = preload("res://src/enums/player_state.gd")

var ObjectsService = preload("res://src/main/services/objects.gd")
var BlackHoleService = preload("res://src/main/services/black_hole.gd")
var objects_service: ObjectsService
var black_hole_service: BlackHoleService

@onready var player := $Player
@onready var playerStateLabel := $Control/PlayerState
@onready var fps_info := $Control/FpsInfo
@onready var misc_info := $Control/MiscInfo
@onready var physics_objects_container := $PhysicsObjects
@onready var moving_black_hole := $BlackHole/Moving
@onready var chasing_black_hole := $BlackHole/Chasing


func _ready():
	get_tree().root.use_occlusion_culling = true
	objects_service = ObjectsService.new(physics_objects_container)
	black_hole_service = BlackHoleService.new(moving_black_hole, chasing_black_hole, physics_objects_container)
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
	objects_service.process(delta)
	misc_info.text = "Balls: " + str(objects_service.objects_generated)
	black_hole_service.process(delta)


func _on_black_holed(body):
	if body.get_class() == "RigidBody3D":
		body.queue_free()
