extends State


var stopRunMove = false

func enter():
	super.enter()
	stopRunMove = false
	owner.set_physics_process(false)
	get_tree().create_timer(3.0).timeout.connect(stopTheRun)
	


	
func exit():
	super.exit()
	
	
func transition():
	if stopRunMove:
		get_parent().change_state("Follow")
		
func stopTheRun():
	stopRunMove = true
	
