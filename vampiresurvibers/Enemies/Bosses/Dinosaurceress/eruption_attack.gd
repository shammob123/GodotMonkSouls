extends State


@export var eruption_scene: PackedScene

# --- CONFIGURATION ---
@export var eruption_count: int = 5      # How many eruptions to spawn
@export var time_between_spawns: float = 0.3 # Time delay between each eruption
@export var eruption_spacing: float = 50.0  # How far apart the eruptions are
@export var attack_windup: float = 0.8       # A brief delay before the attack starts

# --- STATE VARIABLES ---
var player_target = null
var attack_direction = Vector2.ZERO
var eruptions_spawned = 0
var is_finished = false


# This timer will control the spawning of each eruption
var spawn_timer = Timer.new()

func _ready():
	# We add the timer to the scene tree here so it can be processed
	add_child(spawn_timer)
	spawn_timer.wait_time = time_between_spawns
	spawn_timer.one_shot = false # We want it to repeat for each eruption
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	

func enter():
	super.enter()
	owner.set_physics_process(false)
	is_finished = false
	eruptions_spawned = 0
	
	# Get the player's node (you might have a different way of doing this)
	player_target = get_parent().get_parent().get_parent().find_child("Player")
	
	
	if not is_instance_valid(player_target):
		# If player is not valid (e.g., destroyed), just end the state
		is_finished = true
		return
		
	# 1. Look at the player and calculate the direction for the attack
	# We get this ONCE at the beginning so the attack doesn't follow the player
	attack_direction = owner.global_position.direction_to(player_target.global_position)
	
	
	# 2. Wait for the windup, then start spawning
	get_tree().create_timer(attack_windup).timeout.connect(start_spawning)

func start_spawning():
	spawn_timer.start()

func exit():
	super.exit()
	# Always good practice to stop timers on exit just in case
	spawn_timer.stop()

func transition():
	if is_finished:
		# Once the attack is done, go back to following the player
		get_parent().change_state("Follow")

# This function is called every time our spawn_timer times out
func _on_spawn_timer_timeout():
	if eruptions_spawned >= eruption_count:
		# We've spawned all of them, stop the attack
		spawn_timer.stop()
		# Add a small delay after the last eruption before transitioning
		get_tree().create_timer(1.0).timeout.connect(func(): is_finished = true)
		return

	# Increment counter BEFORE using it for calculation
	eruptions_spawned += 1
	
	# Calculate the spawn position
	# Starts one "spacing" unit away from the boss in the attack direction
	var vertical_offset = Vector2(0, 75)
	var spawn_position = owner.global_position + (attack_direction * eruption_spacing * eruptions_spawned)
	spawn_position = spawn_position + vertical_offset

	# Instance the eruption scene
	var eruption_instance = eruption_scene.instantiate()
	eruption_instance.global_position = spawn_position
	
	# Add it to the main scene tree so it's not a child of the boss
	get_tree().get_root().add_child(eruption_instance)
	
	attack_direction = owner.global_position.direction_to(player_target.global_position)
