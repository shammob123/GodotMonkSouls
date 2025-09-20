extends Area2D

@onready var particles = $CPUParticles2D

func _ready():
	particles.emitting = true
	get_tree().create_timer(particles.lifetime).timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Assuming the player has a take_damage function
		body.take_damage(10)
		
		# Optional: To prevent hitting the same player multiple times with one explosion,
		# you can disable the collision shape after the first hit.
		$CollisionShape2D.set_deferred("disabled", true)
