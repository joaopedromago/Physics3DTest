extends Node

class_name BlackHoleService

var moving_black_hole: Area3D
var chasing_black_hole: Area3D
var physics_objects_container: Node3D

var speed := 1.0
var orbitCenter := Vector3(0,0,10)
var orbitRadius := 7.0
var elapsedTime := 0.0

func _init(moving_black_hole_arg: Area3D, chasing_black_hole_arg: Area3D, physics_objects_container_arg: Node3D):
	moving_black_hole = moving_black_hole_arg
	chasing_black_hole = chasing_black_hole_arg
	physics_objects_container = physics_objects_container_arg

func process(delta):
	_move_black_hole(delta)
	_start_chasing_black_hole(delta)

func consume(body):
	body.queue_free()

func _move_black_hole(delta):
	elapsedTime+= delta
	
	moving_black_hole.position.x = orbitCenter.x + orbitRadius * cos(elapsedTime * speed)
	moving_black_hole.position.z = orbitCenter.z + orbitRadius * sin(elapsedTime * speed)

func _start_chasing_black_hole(delta):
		var objects = physics_objects_container.get_children()
		var nearest_object: Node3D
		var nearest_object_distance: float = -1

		for object in objects:
			var distance = object.position.distance_to(chasing_black_hole.position)
			if nearest_object_distance > distance or nearest_object_distance == -1:
				nearest_object_distance = distance
				nearest_object = object

		if nearest_object:
			var direction : Vector3 = (nearest_object.position - chasing_black_hole.position).normalized()
			chasing_black_hole.position += Vector3(direction.x,0,direction.z) * delta * (speed * 2)
