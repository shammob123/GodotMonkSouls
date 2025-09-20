extends State

func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	get_parent().get_parent().queue_free()
