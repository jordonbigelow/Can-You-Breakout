extends RigidBody2D

@export var speed: float = 200.0

var velocity = Vector2(-speed, randi_range(-200, -250))

func _ready() -> void:
	process_mode =  Node.PROCESS_MODE_PAUSABLE
	
func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot_ball"):
	var scaled_velocity: Vector2 = velocity * delta
	var collision: KinematicCollision2D = move_and_collide(scaled_velocity)
	
	if collision:
		var normal: Vector2 = collision.get_normal()
		velocity = velocity.bounce(normal)
		velocity *= 1.010
