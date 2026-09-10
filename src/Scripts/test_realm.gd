class_name TestRealm extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var ore_spawn_points: Node = $OreSpawnPoints
@onready var ore_spawn_timer: Timer = $OreSpawnTimer
@onready var boss_spawn_point: Marker3D = $BossSpawnPoint
const BOSS_THEME = preload("uid://c4n1b2qik86oq")
@onready var music_player: AudioStreamPlayer = $MusicPlayer

@onready var spawn_point_1: EnemySpawnPoint = $SpawnPoints/SpawnPoint1
@onready var spawn_point_2: EnemySpawnPoint = $SpawnPoints/SpawnPoint2
@onready var spawn_point_3: EnemySpawnPoint = $SpawnPoints/SpawnPoint3
@onready var spawn_point_4: EnemySpawnPoint = $SpawnPoints/SpawnPoint4

@onready var available_spawn_points : Array = [
	{"spawn point": spawn_point_1, "occupied": false },
	{"spawn point": spawn_point_2, "occupied": false},
	{"spawn point": spawn_point_3, "occupied": false},
	{"spawn point": spawn_point_4, "occupied": false}
]

var configs_to_beat : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_timer.start()
	ore_spawn_timer.start()
	
	GameManager.hits_taken = 0
	GameManager.xp_gained = 0
	GameManager.misses = 0
	GameManager.shots_fired = 0
	GameManager.levels_gained = 0
	GameManager.enemies_killed = 0
	GameManager.ore_acquired = 0
	GameManager.rounds_beaten = 0
	GameManager.in_arena = true
	SignalBus.round_started.connect(start_spawn_timer)
	SignalBus.round_ended.connect(stop_spawn_timer)
	SignalBus.boss_fight_started.connect(spawn_boss)
	SignalBus.combat_engaged.connect(start_boss_music)
	SignalBus.config_beat.connect(deduct_configs_to_kill)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func start_spawn_timer() -> void:
	spawn_enemy()
	#spawn_timer.start()

func stop_spawn_timer(kill : bool) -> void:
	spawn_timer.wait_time = 0
	spawn_timer.stop()

func spawn_enemy() -> void:
	spawn_timer.stop()
	var spawn_points : Array = spawn_points.get_children()
	
	var config_amount : int = randi_range(1,GameManager.get_max_configs())
	configs_to_beat = config_amount
	print("THIS IS THE SET CONFIG AMOUNT %s" % configs_to_beat)
	for i in range(config_amount):
		var config_list : Array = GameManager.wave_configurations[GameManager.round_number][GameManager.current_round_point]
		var random_config : PackedScene = GameManager.pick_weighted_config(config_list)
		var chosen_configuration : EnemyConfiguration = random_config.instantiate()
		
		var chosen_spawn_point : Dictionary = {}
		while true:
			var candidate = available_spawn_points.pick_random()
			if not candidate["occupied"]:
				chosen_spawn_point = candidate
				break
				
			# Mark spawn point as occupied
			chosen_spawn_point["occupied"] = true
		
		chosen_spawn_point["spawn point"].add_child(chosen_configuration)
		
		var stagger_time : float
		if config_amount >= 2:
			if config_amount >= 3:
				stagger_time = 2.5
			elif config_amount >= 4:
				stagger_time = 2.6
			else:
				stagger_time = 1.8
			await get_tree().create_timer(randf_range(stagger_time-0.2,stagger_time+0.2)).timeout
		var spawn_time : float = GameManager.round_timers[GameManager.round_number]
		var random_time : float = max(1,randf_range(spawn_time - 0.6, spawn_time + 0.5))
		spawn_timer.wait_time = random_time
	
func _on_ore_spawn_timer_timeout() -> void:
	spawn_ore()
	ore_spawn_timer.wait_time = randi_range(PlayerStats.player_stats["Ore Spawn Time"]-2,PlayerStats.player_stats["Ore Spawn Time"])
	ore_spawn_timer.start()


func spawn_ore() -> void:
	var spawn_point : Marker3D = ore_spawn_points.get_children().pick_random()
	var ore : TestOre = preload("uid://bnujpnfle0d5l").instantiate()
	
	ore.global_position = spawn_point.global_position
	add_child(ore)

func spawn_boss() -> void:
	stop_music()
	var boss : BroodMother = preload("uid://d4gg3flbxkfb5").instantiate()
	boss.global_position = boss_spawn_point.global_position
	boss.rotation = boss_spawn_point.rotation
	add_child(boss)

func stop_music() -> void:
	music_player.stop()

func start_boss_music() -> void:
	music_player.stream = BOSS_THEME
	music_player.volume_db = -12.0
	music_player.play()

func choose_new_spawn_point(chosen_spawn_point : EnemySpawnPoint) -> EnemySpawnPoint:
	var new_spawn_point : EnemySpawnPoint = chosen_spawn_point
	
	while new_spawn_point == chosen_spawn_point:
		new_spawn_point = spawn_points.get_children().pick_random()
	
	return new_spawn_point
	
func reset_spawn_point_availability() -> void:
	for point in available_spawn_points:
		point["occupied"] = false

func deduct_configs_to_kill() -> void:
	configs_to_beat -= 1
	print("REMAINING CONFIGS %s" % configs_to_beat)
	if configs_to_beat <= 0:
		start_spawn_timer()
