class_name TestOre extends Node3D

@onready var state_machine: StateMachine = $StateMachine

@export var hurt_state : State
@onready var timer: Timer = $Timer
@export var health : int = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_hit : bool = false
@onready var ore_chunk_area: Marker3D = $OreChunkArea

func _ready() -> void:
	state_machine.init(self)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func damage_ore() -> void:
	state_machine.change_state(hurt_state)

func spawn_ore_chunks() -> void:
	var ore_chunk = preload("uid://btse4bogvqwv3").instantiate()
	ore_chunk_area.add_child(ore_chunk)
