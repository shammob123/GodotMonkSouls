extends Node2D

@export var icon: Texture2D
@onready var summon_animation = $AnimatedSprite2D
@onready var main_sprite = $Sprite2D
@onready var hitbox = $Area2D
@onready var hitbox_collision = $Area2D/CollisionShape2D


func _ready():
	main_sprite.visible = false
	summon_animation.play("Summon")
	summon_animation.animation_finished.connect(_on_summon_finished)
	hitbox.set_deferred("monitoring", true)
	hitbox_collision.set_deferred("disabled", true)

func _on_summon_finished():
	summon_animation.visible = false
	main_sprite.visible = true
	hitbox.monitoring = true
	hitbox_collision.disabled = false
	
func _on_area_2d_area_entered(area):
	if area is PlayerProjectile:

			
		var front_face_normal = self.global_transform.basis_xform(Vector2.RIGHT).normalized()
		
		var incoming_velocity = area.velocity
		
		var dot_product = incoming_velocity.dot(front_face_normal)
		
		var approach_dir = -incoming_velocity
		if approach_dir.dot(front_face_normal) < 0:
			front_face_normal = -front_face_normal
		var reflected_velocity = area.velocity.reflect(front_face_normal)
		
		area.velocity = reflected_velocity

	  
