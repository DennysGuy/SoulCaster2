class_name Stun extends State

@export var idle_state : State

func enter() -> void:
	GameManager.boss_was_stunned = true
	parent.animation_player.play("stun")
	parent.timer.wait_time = 10.0
	parent.timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		return idle_state
	return null
		
