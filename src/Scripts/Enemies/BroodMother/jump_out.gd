class_name JumpOutState extends State

func enter() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(parent, "global_position:y", 20, 0.5)
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
		GameManager.mini_round_started = true
		SignalBus.boss_jumped_out.emit()
		parent.queue_free()
	
	return null
