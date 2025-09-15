extends State

@onready var collision = $"../../PlayerDetection"
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visisble", value)
		
func transition():
	if player_entered:
		get_parent().change_state("Follow")

func _on_player_detection_body_entered(body: Node2D) -> void:
	player_entered = true
