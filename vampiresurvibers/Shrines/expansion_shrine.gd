extends Node2D
const ProjectileScene = preload("res://Player/playerProjectile.tscn")
const SPAWN_RADIUS = 50.0

@export var icon: Texture2D


func _on_area_2d_area_entered(area):
	if area is PlayerProjectile:
		var my_id = self.get_instance_id()
		if area.interacted_shrines.has(my_id):
			return
		
		var new_memory = area.interacted_shrines.duplicate() # Make a copy
		new_memory.append(my_id)
		
		var template_projectile = area
		var incoming_speed = template_projectile.velocity.length()
		
		area.queue_free()
		for i in range(15):
			var angle_degrees = i * 24.0
			var angle_radians = deg_to_rad(angle_degrees)
			var direction = Vector2.from_angle(angle_radians)
			var new_projectile = template_projectile.duplicate(DUPLICATE_SCRIPTS)
			
			
			var spawn_position = self.global_position + (direction * SPAWN_RADIUS)
			
			call_deferred("duplicateProjectile", new_projectile)
			new_projectile.start(spawn_position, direction, new_memory, incoming_speed)


func duplicateProjectile(area):
	get_tree().root.add_child(area)
	
