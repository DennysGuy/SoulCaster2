class_name Stun extends State

@export var idle_state : State
const BOSS_STUN = preload("uid://d4im5en0ji6ug")

func enter() -> void:
	HitStopManager.freeze(0.5,0.05,0.1,0.2)
	GameManager.play_sfx(BOSS_STUN)
	SignalBus.boss_stunned.emit()
	GameManager.boss_was_stunned = true
	parent.animation_player.play("stun")
	parent.timer.wait_time = randi_range(5,7)
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
		
