class_name RollChargeUp extends State

@export var roll_over_state : State

func enter() -> void:
	GameManager.boss_in_roll_mode = true
	parent.animation_player.play("RollOverPrep")
	if GameManager.current_boss_health > round(GameManager.max_boss_health * 75):
		parent.timer.wait_time = 2.5
	elif GameManager.current_boss_health > round(GameManager.max_boss_health * 30) and GameManager.current_boss_health < round(GameManager.max_boss_health * 75):
		parent.timer.wait_time = 2.0
	elif GameManager.current_boss_health < round(GameManager.max_boss_health * 30):
		parent.timer.wait_time = 1.5
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
		
