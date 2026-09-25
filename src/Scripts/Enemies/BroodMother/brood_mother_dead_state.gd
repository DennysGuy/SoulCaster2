class_name BroodMotherDead extends State


func enter() -> void:
	HitStopManager.freeze(0.3,0.05,0.1,0.1)
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
