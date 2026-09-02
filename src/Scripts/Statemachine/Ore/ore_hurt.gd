class_name OreHurt extends State

@export var idle_state : State
const ROCK_HIT_1 = preload("uid://c17om8xpgunbj")
const ROCK_HIT_2 = preload("uid://b8yne63pqyfmt")
const ROCK_HIT_3 = preload("uid://chkpuej5s0s6t")
const ROCK_DEATH_1 = preload("uid://dex116hwebgp")

@onready var rock_hits : Array[AudioStream] = [ROCK_HIT_1,ROCK_HIT_2,ROCK_HIT_3]

func enter() -> void:
	parent.animation_player.play(animation_name)
	parent.timer.wait_time = 0.4
	GameManager.play_sfx(rock_hits.pick_random())
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
			
		GameManager.play_sfx(ROCK_DEATH_1)
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
