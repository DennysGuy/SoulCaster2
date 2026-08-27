class_name TestRealm extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var ore_spawn_points: Node = $OreSpawnPoints
@onready var ore_spawn_timer: Timer = $OreSpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()
	ore_spawn_timer.start()
	GameManager.in_arena = true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	spawn_timer.wait_time = randi_range(3,7)
	spawn_timer.start()


func spawn_enemy() -> void:
	var spawn_points : Array = spawn_points.get_children()
	
	var chosen_spawn_point : EnemySpawnPoint = spawn_points.pick_random()
	
	var spawn_count : int = randi_range(1,2)
	
	
	for i in range(spawn_count):
		var enemy : Enemy = preload("uid://be7m7tct4a7cq").instantiate()
		
		if chosen_spawn_point.index == 1 or chosen_spawn_point.index == 3:
			enemy.global_position = chosen_spawn_point.global_position + Vector3(randf_range(-10.0, 10.0), 0.0, 0.0)
		else:
			enemy.global_position = chosen_spawn_point.global_position + Vector3(0.0, 0.0, randf_range(-10.0, 10.0))
	
		enemy.rotation = chosen_spawn_point.rotation
		add_child(enemy)
	

func _on_ore_spawn_timer_timeout() -> void:
	spawn_ore()
	ore_spawn_timer.wait_time = randi_range(4,8)
	ore_spawn_timer.start()


func spawn_ore() -> void:
	var spawn_point : Marker3D = ore_spawn_points.get_children().pick_random()
	var ore : TestOre = preload("uid://bnujpnfle0d5l").instantiate()
	
	ore.global_position = spawn_point.global_position
	add_child(ore)
