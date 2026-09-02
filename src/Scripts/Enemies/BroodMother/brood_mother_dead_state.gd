class_name BroodMotherDead extends State


func enter() -> void:
	parent.animation_player.play("death")
	parent.timer.wait_time = 3.0
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		SignalBus.boss_defeated.emit()
	
	return null
