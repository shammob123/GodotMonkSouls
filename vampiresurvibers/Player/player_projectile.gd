class_name PlayerProjectile

extends Area2D

@export var speed = 200
var velocity = Vector2.ZERO
var interacted_shrines: Array = []
@export var lifespan: float = 2.0

func start(start_position, direction, initial_memory: Array = [], current_speed: float = -1.0):
	self.global_position = start_position
	
	var final_speed = speed
	if current_speed > 0: # Check if a valid speed was passed in
		final_speed = current_speed
	
	self.velocity = direction.normalized() * final_speed
	self.interacted_shrines = initial_memory # Clones will inherit the memory.
	
	self.speed = final_speed
	
	self.scale = Vector2(.5, .5)

func _physics_process(delta):
	position += velocity * delta
	rotation = velocity.angle()
	
	lifespan -= delta
	
	if lifespan <= 0:
		queue_free()
		return
 

  


func _on_body_entered(body: Node2D) -> void:
	body.health -= 1
