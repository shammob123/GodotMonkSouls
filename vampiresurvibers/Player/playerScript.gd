#Player.gd

extends CharacterBody2D

## == Nodes ==
@onready var weapon_pivot = $WeaponPivot
@onready var weapon_sprite = $WeaponPivot/WeaponSprite
@onready var projectile_spawn_point = $WeaponPivot/WeaponSprite/Marker2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var fire_rate_timer = $FireCooldown
@onready var swap_cooldown_timer = $SwapCooldown
@onready var shrine_label = $ShrineLabel
@onready var cast_timer = Timer.new()

## == Exported ==
@export var acceleration := 25.0
@export var friction := 25
@export var max_speed := 200.0
@export var speed_multiplier := 10.0

## == Constants == 
const ProjectileScene = preload("res://Player/playerProjectile.tscn")
const MirrorShrineScene = preload("res://Shrines/MirrorShrine.tscn")
const AcceleratorShrineScene = preload("res://Shrines/AcceleratorShrine.tscn")
const ExpansionShrineScene = preload("res://Shrines/ExpansionShrine.tscn")

## == Variables == 
var can_swap_shrine = true
var current_shrine_index: int = 0
var state = PlayerState.NORMAL
var input_vector := Vector2.ZERO
var can_fire = true
var facing_direction = 1

enum PlayerState {
	NORMAL,
	DODGING,
	CASTING,
	STUNNED
}

func _ready():
	add_child(cast_timer)
	cast_timer.one_shot = true
	cast_timer.timeout.connect(_on_cast_timer_timeout)
	
func _physics_process(delta: float) -> void:
	handle_movement(delta)
	
	match state:
		PlayerState.NORMAL:					
			if Input.is_action_pressed("Spellcast"):
				start_casting()
			
		PlayerState.CASTING:
			pass
		
	if Input.is_action_pressed("SwapShrine") and can_swap_shrine:
		swapShrine()
		can_swap_shrine = false
		swap_cooldown_timer.start(0.1)
	
	move_and_slide()
	update_animation()





func _process(delta):		
	var mouse_position = get_global_mouse_position()
	weapon_pivot.look_at(mouse_position)
	
	var to_mouse = get_global_mouse_position() - self.global_position
	if to_mouse.dot(Vector2.RIGHT) < 0:
		weapon_sprite.scale.y = -1
	else:
		weapon_sprite.scale.y = 1
		
	match state:
		PlayerState.NORMAL:					
			if Input.is_action_pressed("Primary") and can_fire:
				start_fire()
			
		PlayerState.CASTING:
			pass
			

func start_fire():
	can_fire = false
	fire_rate_timer.start()
	fire()
	
func fire():
	var projectile = ProjectileScene.instantiate()
	var direction = Vector2.from_angle(projectile_spawn_point.global_rotation)
	get_tree().root.add_child(projectile)
	projectile.start(projectile_spawn_point.global_position, direction)

func fireShrine():

	var shrine: Node2D

	match current_shrine_index:
		0: shrine = ExpansionShrineScene.instantiate()
		1: shrine = AcceleratorShrineScene.instantiate()
		2: shrine = MirrorShrineScene.instantiate()
		_: return
	
	
	
	shrine.global_position = get_global_mouse_position()
	# -- Add back if rotation of shrine needed -- 
	#var direction_vector = shrine.global_position - self.global_position
	#shrine.global_rotation = direction_vector.angle() + deg_to_rad(90)
	
	get_tree().root.add_child(shrine)
	

func _on_fire_cooldown_timeout() -> void:
	can_fire = true


func update_animation():
	if state != PlayerState.NORMAL:
		return

	if velocity.x > 0:
		facing_direction = 1
	elif velocity.x < 0:
		facing_direction = -1

	var anim_name = ""

	if velocity.length() > 10:
		if (facing_direction == 1):
			anim_name = "RunRight"
		else:
			anim_name = "RunLeft"
	else:
		if (facing_direction == 1):
			anim_name = "IdleRight"
		else:
			anim_name = "IdleLeft"

	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)


		
func play_animation_with_duration(name: String, duration: float):
	var frame_count = animated_sprite.sprite_frames.get_frame_count(name)
	var fps = frame_count / duration
	animated_sprite.animation = name
	animated_sprite.speed_scale = fps / animated_sprite.sprite_frames.get_animation_speed(name)
	animated_sprite.play()
	
func handle_movement(delta: float):
	if state == PlayerState.CASTING:
		# No input, just apply friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * speed_multiplier)
		return

	input_vector = Vector2(
		Input.get_action_strength("Move Right") - Input.get_action_strength("Move Left"),
		Input.get_action_strength("Move Down") - Input.get_action_strength("Move Up")
	).normalized()

	if input_vector != Vector2.ZERO:
		velocity += input_vector * acceleration * delta * speed_multiplier
		velocity = velocity.limit_length(max_speed * delta * speed_multiplier)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * speed_multiplier)
		
		
## == Spellcasting Logic == 
func start_casting():
	state = PlayerState.CASTING
	can_fire = false
	play_animation_with_duration("SpellcastRight", 1.0)
	cast_timer.start(1.0)
			
func _on_cast_timer_timeout():
	state = PlayerState.NORMAL
	can_fire = true
	fireShrine()
	
func swapShrine():
	current_shrine_index += 1
	if current_shrine_index > 2:
		current_shrine_index = 0
	
	match current_shrine_index:
		0:
			shrine_label.text = "Nova"
		1:
			shrine_label.text = "Accelerate"
		2:
			shrine_label.text = "Reflect"
		


func _on_swap_cooldown_timeout() -> void:
	can_swap_shrine = true
