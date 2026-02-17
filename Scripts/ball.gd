extends RigidBody2D

@export var speed: float = 200.0
@export var speed_increase: float = 1.01
signal hit_brick(brick)
signal hit_paddle
signal hit_wall

var velocity = Vector2(-speed, randi_range(-200, -250))

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
func _physics_process(delta: float) -> void:
	var scaled_velocity: Vector2 = velocity * delta
	var collision: KinematicCollision2D = move_and_collide(scaled_velocity)
	
	if collision:
		if collision.get_collider().name.contains("StaticBody2D") or collision.get_collider().name.contains("Brick"):
			increase_velocity()
			hit_brick.emit(collision.get_collider())
		elif collision.get_collider().name.contains("Paddle"):
			hit_paddle.emit()
		else:
			hit_wall.emit()
			
		var normal: Vector2 = collision.get_normal()
		velocity = velocity.bounce(normal)
		
func increase_velocity() -> void:
		velocity *= speed_increase
