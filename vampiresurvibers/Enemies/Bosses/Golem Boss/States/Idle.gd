extends State

@onready var collision = $"../../FlipAxis/PlayerDetection"

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)

		
func transition():
	if player_entered:
		get_parent().change_state("Follow")

func _on_player_detection_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(5.0).timeout
	player_entered = true
