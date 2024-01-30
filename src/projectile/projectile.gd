extends Node3D

@onready var mesh = $Mesh
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var time := 0.0

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position += transform.basis * Vector3(0,0,-Application.BULLET_SPEED) * delta
	if ray.is_colliding() and ray.get_collider() and ray.get_collider() is RigidBody3D:
		get_parent().emit_signal("rigid_body_hit", ray.get_collider())
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()
