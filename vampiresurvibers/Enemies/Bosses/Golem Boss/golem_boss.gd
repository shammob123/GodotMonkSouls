extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $FlipAxis/Pivot/Sprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var flipAxis = $FlipAxis


var direction : Vector2

var health = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")

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
	
	




func _on_attack_hitboxes_body_entered(body: Node2D) -> void:
	if (body is Player):
		body._health -= 10
