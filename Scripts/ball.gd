extends RigidBody2D

@export var speed: float = 200.0
signal hit_brick(_node_name: String)

var velocity = Vector2(-speed, randi_range(-200, -250))

func _ready() -> void:
	process_mode =  Node.PROCESS_MODE_PAUSABLE
	
func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot_ball"):
	var scaled_velocity: Vector2 = velocity * delta
	var collision: KinematicCollision2D = move_and_collide(scaled_velocity)
	
	if collision:
		if collision.get_collider().name.contains("Brick"):
			# grabs the name of the collider to ensure the proper brick gets removed
			# then it passes the name to the signal
			var _node_name: String = collision.get_collider().name
			hit_brick.emit(_node_name)
		var normal: Vector2 = collision.get_normal()
		velocity = velocity.bounce(normal)
		velocity *= 1.010
