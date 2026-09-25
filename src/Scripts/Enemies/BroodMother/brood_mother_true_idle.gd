class_name BroodMotherTrueIdle extends State

var timer : float = 100
@export var attack_state : State
@export var jump_up_state : State
@export var roll_prep_state : State

@export var jump_left : State
@export var jump_right : State
@export var jump_center : State

@onready var jump_states : Array[State] = [jump_left, jump_right, jump_center]

func enter() -> void:
	parent.animation_player.play("Idle")
	timer = randf_range(40.0,60.0)

func exit() -> void:
	GameManager.boss_was_stunned = false

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	
	timer -= 20 * _delta
	if timer <= 0:
		if GameManager.boss_was_stunned:
			return jump_up_state
			
		return jump_states.pick_random()
	
	return null

func process_physics(_delta: float) -> State:
	return null



	
	
