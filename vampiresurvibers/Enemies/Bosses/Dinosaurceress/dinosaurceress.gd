extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var flipAxis = $FlipAxis


var direction : Vector2

var health = 100:
	set(value):
		health = value



func _ready():
	set_physics_process(false)
	
func _process(_delta):
	direction = player.position - position
	
	if direction.x < 0:
		flipAxis.scale.x = -1

	else:
		flipAxis.scale.x = 1

		
func _physics_process(delta):
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	
	
