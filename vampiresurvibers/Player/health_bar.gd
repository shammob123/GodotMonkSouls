extends ProgressBar


@onready var damageDelayTimer = $DamageDelayTimer
@onready var damageBar = $DamageBar



var health = 0 : set = _set_health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damageBar.max_value = health
	damageBar.value = health
	
func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < prev_health:
		damageDelayTimer.start()
	else:
		damageBar.value = health
		


func _on_damage_delay_timer_timeout() -> void:
	damageBar.value = health


func _on_player_health_changed(new_health: Variant) -> void:
	_set_health(new_health)
