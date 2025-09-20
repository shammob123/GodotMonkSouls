extends State
@onready var attackCooldownTimer = $"../../AttackCooldown"

var readyToAttack = false

func enter():
	readyToAttack = false
	super.enter()
	owner.set_physics_process(true)
	attackCooldownTimer.start()

	
func exit():
	super.exit()
	
	
func transition():
	if readyToAttack:
		get_parent().change_state("EruptionAttack")
	


func _on_attack_cooldown_timeout() -> void:
	readyToAttack = true
