class_name BroodMotherTrueIdle extends State

var timer : float = 100
@export var attack_state : State

func enter() -> void:
	parent.animation_player.play("Idle")
	timer = randf_range(40.0,60.0)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	
	timer -= 20 * _delta
	if timer <= 0:
		return attack_state
	
	return null

func process_physics(_delta: float) -> State:
	return null
