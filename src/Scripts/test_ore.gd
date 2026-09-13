class_name TestOre extends Node3D

@onready var state_machine: StateMachine = $StateMachine
@export var bolt_position : Marker3D
@export var hurt_state : State
@onready var timer: Timer = $Timer
@export var health : int = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var lock_on_target: LockOnTarget = $LockOnTarget


var can_hit : bool = false
@onready var ore_chunk_area: Marker3D = $OreChunkArea

func _ready() -> void:
	SignalBus.enemy_hit.connect(hide_lock_on_target)
	state_machine.init(self)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func damage_ore() -> void:
	lock_on_target.show()
	SignalBus.enemy_hit.emit(self)
	state_machine.change_state(hurt_state)

func show_lock_on_target() -> void:
	lock_on_target.show()

func hide_lock_on_target(target : Node3D) -> void:
	if target == self:
		return
	
	lock_on_target.hide()
	
func spawn_ore_chunks() -> void:
	var ore_chunk = preload("uid://btse4bogvqwv3").instantiate()
	ore_chunk_area.add_child(ore_chunk)
