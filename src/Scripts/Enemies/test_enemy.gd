class_name TestEnemy extends Enemy

@onready var timer: Timer = $Timer

@onready var skeleton_3d: Skeleton3D = $"rat(2)/rat/Skeleton3D"

var player_in_range : bool = false

func _ready() -> void:
	super()
	max_enemy_health = randi_range(max_enemy_health-20,max_enemy_health+10)
	health = max_enemy_health
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)
	#ake_materials_unique(skeleton_3d)

func _process(delta: float) -> void:
	super(delta)
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _on_player_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		state_machine.change_state(attack_state)

func play_walk_animation(animation_name : String) -> void:
	var animation : Animation = animation_player.get_animation(animation_name)
	var length = animation.length
	var random_frame : float = randf_range(0, length)
	animation_player.play(animation_name)
	animation_player.seek(random_frame,true)
