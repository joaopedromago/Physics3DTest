extends Node

class_name SkillsService

var player: CharacterBody3D

var is_skill_aiming := false
var moving_object: RigidBody3D
var reticle: CenterContainer
var twist_pivot: Node3D
var pitch_pivot: Node3D

var projectile = load("res://src/projectile/projectile.tscn")

func _init(player_arg: CharacterBody3D, reticle_arg: CenterContainer, twist_pivot_arg: Node3D, pitch_pivot_arg: Node3D):
	player = player_arg
	reticle = reticle_arg
	twist_pivot = twist_pivot_arg
	pitch_pivot = pitch_pivot_arg

func process(delta: float):
	if Input.is_action_just_pressed("aim_skill"):
		is_skill_aiming = true
	if Input.is_action_just_released("aim_skill"):
		_drop_object()
		is_skill_aiming = false
	if Input.is_action_just_pressed("use_skill") and is_skill_aiming:
		if moving_object:
			_throw_object(delta)
		else:
			_shoot()			
	reticle.visible = is_skill_aiming and !moving_object
	_move_object(delta)

func _shoot():
	var instance = projectile.instantiate()
	instance.position = Vector3(twist_pivot.position.x, twist_pivot.position.y, twist_pivot.position.z)
	instance.rotation = Vector3(pitch_pivot.rotation.x,twist_pivot.rotation.y,0)
	player.add_child(instance)

func _drop_object():
	if moving_object:
		moving_object.linear_velocity = Vector3.ZERO
		moving_object = null
	
func _throw_object(delta: float):
	moving_object.linear_velocity = Vector3.ZERO
	var t_basis = twist_pivot.transform.basis
	var p_basis = pitch_pivot.transform.basis
	var basis = Basis(t_basis.x,t_basis.y,Vector3(t_basis.z.x,p_basis.z.y,t_basis.z.z))
	moving_object.apply_impulse(basis * Vector3(0,0,-Application.BULLET_SPEED * 100) * delta)
	moving_object = null
	
func _move_object(delta: float):
	if moving_object:		
		var target_position = player.position + twist_pivot.global_transform.basis.z * -2
		target_position.y += 2
		var new_position = moving_object.global_transform.origin.lerp(target_position, 2 * delta)
		moving_object.global_transform.origin = new_position
	
