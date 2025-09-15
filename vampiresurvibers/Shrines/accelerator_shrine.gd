extends Node2D

@export var icon: Texture2D

func _on_area_2d_area_entered(area):
	if area is PlayerProjectile:

			
		area.velocity = area.velocity * 2
	  
