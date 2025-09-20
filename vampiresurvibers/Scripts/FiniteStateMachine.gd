extends Node2D

@export var initial_state: State

@onready var debug_label = get_parent().find_child("debug") 

var current_state: State
var previous_state: State

func _ready():
	if initial_state:
		current_state = initial_state
	else:
		# Fallback to the first child just in case
		print("WARNING: No initial state set in the FSM Inspector. Defaulting to first child.")
		current_state = get_child(0) as State
		
	previous_state = current_state
	current_state.enter()

func change_state(state):
	current_state = find_child(state) as State
	previous_state.exit()
	current_state.enter()
	previous_state = current_state

func _physics_process(_delta):
	# Update the debug label every frame based on the one true current_state
	if is_instance_valid(current_state):
		debug_label.text = current_state.name
