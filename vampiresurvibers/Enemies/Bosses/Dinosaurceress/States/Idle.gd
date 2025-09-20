extends State

@onready var collision = $"../../FlipAxis/PlayerDetection"
@onready var collisionBox = $"../../FlipAxis/PlayerDetection/CollisionShape2D"
@onready var playerCamera = get_parent().get_parent().get_parent().find_child("Player").find_child("Camera2D")
@onready var roarTimer = $"../../RoarTimer"

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
	
	

		
func transition():	
	if player_entered:
		get_parent().change_state("Follow")
		


func _on_player_detection_body_entered(body: Node2D) -> void:
	if (body is Player):
		
		if player_entered:
			return

		playerCamera.apply_shake()
		roarTimer.start()


func _on_roar_timer_timeout() -> void:
	player_entered = true
