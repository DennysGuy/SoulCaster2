class_name JumpOutState extends State

func enter() -> void:
	parent.animation_player.play("JumpOut")
	parent.timer.wait_time = 1.0

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		GameManager.mini_round_started = true
		queue_free()
	
	return null
