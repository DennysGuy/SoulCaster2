class_name TestEnemy extends Enemy

@onready var timer: Timer = $Timer

@onready var skeleton_3d: Skeleton3D = $"rat(2)/rat/Skeleton3D"
@onready var walk_particles: GPUParticles3D = $WalkParticles
@onready var walk_particles_2: GPUParticles3D = $WalkParticles2
const DEEP_FOOT_STEP_1 = preload("uid://iq5dsaia0662")
const DEEP_FOOT_STEP_2 = preload("uid://d14qp1vn7dqfk")


@onready var spawn_in_player: AnimationPlayer = $SpawnInPlayer

var player_in_range : bool = false

func _ready() -> void:
	super()
	max_enemy_health = randi_range(max_enemy_health-5,max_enemy_health)
	health = max_enemy_health
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)
	#ake_materials_unique(skeleton_3d)
	if spawn_in_player:
		spawn_in_player.play("SpawnIn")

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

func emit_walk_particles() -> void:
	walk_particles.process_material.gravity = global_basis.z
	walk_particles.emitting = true

func emit_walk_particles_2() -> void:
	walk_particles_2.process_material.gravity = global_basis.z
	walk_particles_2.emitting = true

func play_foot_step_1() -> void:
	leap_player.stream = DEEP_FOOT_STEP_1
	leap_player.play()

func play_foot_step_2() -> void:
	leap_player.stream = DEEP_FOOT_STEP_2
	leap_player.play()
