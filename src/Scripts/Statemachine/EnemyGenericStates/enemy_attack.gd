class_name EnemyAttack extends State

@export var dig_state : State

func enter() -> void:
	parent.animation_player.play("Attack")
	parent.can_hurt = false
	parent.timer.wait_time = 1.0
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		return dig_state
		
	return null
