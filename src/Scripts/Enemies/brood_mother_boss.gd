class_name BroodMother extends Enemy

@onready var timer: Timer = $Timer
@onready var birth_area: Marker3D = $BirthArea
@export var true_idle_state : State
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
	SignalBus.shake_camera.emit(1.5)

func spawn_baby() -> void:
	var baby : BabyBullet = preload("uid://c0c8523kico71").instantiate()
	baby.global_position = birth_area.global_position + Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	get_parent().add_child(baby)
	SignalBus.shake_camera.emit(0.3)

func start_combat() -> void:
	state_machine.change_state(true_idle_state)
