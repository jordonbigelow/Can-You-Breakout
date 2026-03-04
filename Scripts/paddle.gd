extends CharacterBody2D

@export var speed: float = 700.0
@export var slow_down_speed: float = 60.0 

var direction_left: float = -1.0 * speed
var direction_right: float = 1.0 * speed

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_axis("move_left", "move_right")
	
	if input_direction != 0:
		velocity.x = move_toward(velocity.x, input_direction * abs(direction_right), slow_down_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, slow_down_speed)
		
	#if Input.is_action_pressed("move_left"):
		#velocity.x = move_toward(velocity.x, direction_left, slow_down_speed)
	#elif Input.is_action_pressed("move_right"):
		#velocity.x = move_toward(velocity.x, direction_right, slow_down_speed)
	#else:
		#velocity.x = move_toward(velocity.x, 0.0, slow_down_speed)
	move_and_slide()
