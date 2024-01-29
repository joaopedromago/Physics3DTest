extends Node

class_name SkillsService

var player: CharacterBody3D
var reticle: CenterContainer

var is_skill_aiming := false
var moving_object: RigidBody3D

func _init(player_arg: CharacterBody3D, reticle_arg: CenterContainer):
	player = player_arg
	reticle = reticle_arg

func process(delta: float):
	if Input.is_action_just_pressed("aim_skill"):
		is_skill_aiming = true
	if Input.is_action_just_released("aim_skill"):
		moving_object = null
		is_skill_aiming = false
	if Input.is_action_just_pressed("use_skill") and is_skill_aiming:
		_set_moving_object()
	reticle.visible = is_skill_aiming

func _set_moving_object():
	# TODO: GET TARGET FROM AIMING DIRECTION
	pass
