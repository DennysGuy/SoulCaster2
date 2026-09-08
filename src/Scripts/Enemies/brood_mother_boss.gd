class_name BroodMother extends Enemy

@onready var timer: Timer = $Timer
@onready var birth_area: Marker3D = $BirthArea
@export var true_idle_state : State

const BOSS_DEATH = preload("uid://bcruebecyj6as")


const BOSSFALL = preload("uid://dblm77efdm7xg")
const BOSS_SHOOT_1 = preload("uid://d3oq8dtxobcnf")

const BOSS_BIRTH_1 = preload("uid://l1xr5ri1i482")
const BOSS_BIRTH_2 = preload("uid://8ytsfdi3lbgl")
const BOSS_BIRTH_3 = preload("uid://ciu023akg2tum")
const BOSS_BIRTH_4 = preload("uid://b0xck7v14lb50")

@onready var boss_birth_groans : Array[AudioStream] = [BOSS_BIRTH_1,BOSS_BIRTH_2,BOSS_BIRTH_3,BOSS_BIRTH_4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.combat_engaged.connect(start_combat)
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func fall_shake() -> void:
	GameManager.play_sfx(BOSSFALL)
	SignalBus.shake_camera.emit(1.5)

func spawn_baby() -> void:
	play_boss_shoot_sfx()
	var baby : BabyBullet = preload("uid://c0c8523kico71").instantiate()
	baby.global_position = birth_area.global_position + Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	get_parent().add_child(baby)
	SignalBus.shake_camera.emit(0.5)

func start_combat() -> void:
	state_machine.change_state(true_idle_state)

func play_ground_slam() -> void:
	GameManager.play_sfx(BOSSFALL)

func play_boss_shoot_sfx() -> void:
	GameManager.play_sfx(BOSS_SHOOT_1, -1.0)

func play_boss_birth_moan() -> void:
	GameManager.play_sfx(boss_birth_groans.pick_random(), -1.0)

func play_boss_death() -> void:
	GameManager.play_sfx(BOSS_DEATH)
