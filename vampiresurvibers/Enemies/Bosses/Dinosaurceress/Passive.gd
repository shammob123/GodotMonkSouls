extends State

@onready var collision = $"../../FlipAxis/PlayerDetection"
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visisble", value)
		
func transition():
	if player_entered:
		get_parent().change_state("Idle")

func _on_player_detection_body_entered(body: Node2D) -> void:
	player_entered = true
	await get_tree().create_timer(5.0).timeout
