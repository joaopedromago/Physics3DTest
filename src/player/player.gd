extends CharacterBody3D

var CameraService = preload("res://src/player/services/camera.gd")
var MovementService = preload("res://src/player/services/movement.gd")
var AnimationService = preload("res://src/player/services/animation.gd")
var StatusService = preload("res://src/player/services/status.gd")
var SkillsService = preload("res://src/player/services/skills.gd")

var camera_service: CameraService
var movement_service: MovementService
var animation_service: AnimationService
var status_service: StatusService
var skills_service: SkillsService

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var camera_anti_collider := $TwistPivot/PitchPivot/AntiCollider
@onready var animation_player := $Body/Mesh/AnimationPlayer
@onready var body := $Body
@onready var reticle := $Interface/Reticle

const PlayerState = preload("res://src/enums/player_state.gd")

var state := PlayerState.Idle
var action_direction: Vector3

signal rigid_body_hit(object: RigidBody3D)

func _ready():
	action_direction = rotation
	status_service = StatusService.new(self)
	animation_service = AnimationService.new(self, animation_player)
	movement_service = MovementService.new(self, body, status_service, twist_pivot, pitch_pivot)
	camera_service = CameraService.new(self, twist_pivot, pitch_pivot, camera_anti_collider)
	skills_service = SkillsService.new(self, reticle, twist_pivot, pitch_pivot)

func _process(delta: float):
	camera_service.process(delta)
	skills_service.process(delta)

func _physics_process(delta: float):
	_handle_gravity(delta)
	movement_service.process(delta)
	animation_service.process(delta)
	move_and_slide()
	_handle_collision(delta)


func _handle_gravity(delta: float):
	if not is_on_floor():
		velocity.y -= Application.gravity * delta

func _handle_collision(delta: float):
	for col_idx in get_slide_collision_count():
		var collision := get_slide_collision(col_idx)
		if collision and collision.get_collider() is RigidBody3D:
			collision.get_collider().apply_impulse(-collision.get_normal() * 100 * delta, collision.get_position() - collision.get_collider().global_position)


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_service.handle_camera_input(event)


func _on_rigid_body_hit(object: RigidBody3D):
	if !skills_service.moving_object:
		skills_service.moving_object = object
