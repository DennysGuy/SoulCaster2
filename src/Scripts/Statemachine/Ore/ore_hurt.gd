class_name OreHurt extends State

@export var idle_state : State

func enter() -> void:
	parent.animation_player.play(animation_name)
	parent.timer.wait_time = 0.4
	
	var damage : int = 1
	
	if GameManager.fortified_pistol_bullets and !GameManager.rifle_owned:
		damage = 2
	
	if GameManager.fortified_rifle_bullets and GameManager.rifle_owned:
		damage = 2
	
	parent.health -= damage

func exit() -> void:
	if parent.health <= 0:
		var ore_received : int = 1
		
		if GameManager.fortified_pistol_bullets and !GameManager.rifle_owned:
			ore_received = 2
		
		if GameManager.fortified_rifle_bullets and GameManager.rifle_owned:
			ore_received = 2
			
		PlayerStats.player_stats["Ore"] += ore_received
			
			
		SignalBus.ore_gathered.emit(1)
		parent.queue_free()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		return idle_state
	
	return null
