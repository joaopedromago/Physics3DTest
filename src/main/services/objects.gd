extends Node

class_name ObjectsService

var time := 0.0
var objects_generated := 0
var physics_objects_container: Node3D
var rng: RandomNumberGenerator
var multi_mesh_instance: MultiMeshInstance3D

func _init(physics_objects_container_arg: Node3D):
	physics_objects_container = physics_objects_container_arg
	rng = RandomNumberGenerator.new()
	#_create_multi_mesh_instance()

func process(delta):
	time += delta
	_generate_physics_objects(delta)

func _create_multi_mesh_instance():
	multi_mesh_instance = MultiMeshInstance3D.new()
	var multi_mesh = MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	
	var sphere_mesh = SphereMesh.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = _generate_random_rgb()
	sphere_mesh.material = material
	
	multi_mesh.mesh = sphere_mesh
	multi_mesh_instance.multimesh = multi_mesh
	

func _generate_physics_objects(delta):
	if  time > objects_generated:
		objects_generated += 1
		var object = RigidBody3D.new()
		var physics = PhysicsMaterial.new()
		object.position.y = 20
		object.position.z = rng.randf_range(-1.0, 1.0) + 10
		object.position.x = rng.randf_range(-1.0, 1.0)
		object.physics_material_override = physics
		
		var shape = CollisionShape3D.new()
		
		var sphere_shape = SphereShape3D.new()
		shape.shape = sphere_shape
		
		var mesh = MeshInstance3D.new()
		var sphere_mesh = SphereMesh.new()
		var material = StandardMaterial3D.new()
		material.albedo_color = _generate_random_rgb()
		sphere_mesh.material = material
		mesh.mesh = sphere_mesh
		
		object.add_child(shape)
		object.add_child(mesh)
		physics_objects_container.add_child(object)
		
func _generate_random_rgb():
	var seed = randi()
	
	var r = seed % 256
	var g = (seed / 256) % 256
	var b = (seed / (256 * 256)) % 256
	
	return Color(r / 255.0, g / 255.0, b / 255.0)
	