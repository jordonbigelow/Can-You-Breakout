extends CharacterBody2D

@export var speed: float = 900.0
@export var slow_down_speed: float = 55.0 
#var motion: Vector2

var direction_left: float = -1.0 * speed
var direction_right: float = 1.0 * speed

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		velocity.x = move_toward(velocity.x, direction_left, slow_down_speed)
		#motion.x = move_toward(motion.x, (-1 * speed), slow_down_speed)
	elif Input.is_action_pressed("move_right"):
		velocity.x = move_toward(velocity.x, direction_right, slow_down_speed)
		#motion.x = move_toward(motion.x, (1 * speed), slow_down_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, slow_down_speed)
		#motion.x = move_toward(motion.x, 0.0, slow_down_speed)
	move_and_slide()
	#var collision: KinematicCollision2D = move_and_collide(motion)
	
	#if collision:
		#print(collision.get_travel())
