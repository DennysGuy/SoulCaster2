class_name RollChargeUp extends State

@export var roll_over_state : State

func enter() -> void:
	parent.animation_player.play("RollOverPrep")
	parent.timer.wait_time = 2.0
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		return roll_over_state
	
	return null
		
