class_name TestRealm extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var ore_spawn_points: Node = $OreSpawnPoints
@onready var ore_spawn_timer: Timer = $OreSpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_timer.start()
	ore_spawn_timer.start()
	GameManager.in_arena = true
	SignalBus.round_started.connect(start_spawn_timer)
	SignalBus.round_ended.connect(stop_spawn_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	var spawn_time : int = GameManager.round_timers[GameManager.round_number]
	
	match GameManager.current_round_point:
		GameManager.ROUND_POINT.HALF_WAY:
			print("Im at the half way point")
			spawn_time -= 1
			print("This is spawn time %s" % spawn_time) 
		GameManager.ROUND_POINT.THREE_QUARTER:
			print("I'm three quarters there")
			spawn_time -= 2
			print("This is spawn time %s" % spawn_time) 
		_:
			print("Im at the beginning")
			print("This is spawn time %s" % spawn_time) 
	
	spawn_timer.wait_time = randi_range(spawn_time-2,spawn_time+2)
	spawn_timer.start()

func start_spawn_timer() -> void:
	spawn_timer.wait_time = randi_range(GameManager.round_timers[GameManager.round_number]-2,GameManager.round_timers[GameManager.round_number]+2)
	spawn_timer.start()

func stop_spawn_timer() -> void:
	spawn_timer.stop()

func spawn_enemy() -> void:
	var spawn_points : Array = spawn_points.get_children()
	
	var chosen_spawn_point : EnemySpawnPoint = spawn_points.pick_random()
	
	var spawn_count : int = randi_range(GameManager.minimum_spawn[GameManager.round_number],GameManager.maximum_spawn[GameManager.round_number])
	
	for i in range(spawn_count):
		
		var chance_to_bulk : int = 0
		if GameManager.round_number == 1:
			chance_to_bulk = 20
		elif GameManager.round_number == 2:
			chance_to_bulk = 40
		
		var enemy : Enemy
		
		var rand_num : int = randi_range(1,100)
		if rand_num < chance_to_bulk:
			enemy = preload("uid://belgdl70endw6").instantiate()
		else:
			enemy = preload("uid://be7m7tct4a7cq").instantiate()
		
		if chosen_spawn_point.index == 1 or chosen_spawn_point.index == 3:
			enemy.global_position = chosen_spawn_point.global_position + Vector3(randf_range(-10.0, 10.0), 0.0, 0.0)
		else:
			enemy.global_position = chosen_spawn_point.global_position + Vector3(0.0, 0.0, randf_range(-10.0, 10.0))
	
		enemy.rotation = chosen_spawn_point.rotation
		add_child(enemy)
	

func _on_ore_spawn_timer_timeout() -> void:
	spawn_ore()
	ore_spawn_timer.wait_time = randi_range(PlayerStats.player_stats["Ore Spawn Time"]-2,PlayerStats.player_stats["Ore Spawn Time"]+2)
	ore_spawn_timer.start()


func spawn_ore() -> void:
	var spawn_point : Marker3D = ore_spawn_points.get_children().pick_random()
	var ore : TestOre = preload("uid://bnujpnfle0d5l").instantiate()
	
	ore.global_position = spawn_point.global_position
	add_child(ore)
