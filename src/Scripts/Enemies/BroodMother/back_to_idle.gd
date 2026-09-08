class_name BackToIdle extends State

@export var idle_state : State
const BOSS_BACK_TO_IDLE = preload("uid://cqhrjvjm84tcy")

func enter() -> void:
	parent.animation_player.play("back to idle")
	parent.timer.wait_time = 1.25
	parent.timer.start()
	GameManager.play_sfx(BOSS_BACK_TO_IDLE)
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
