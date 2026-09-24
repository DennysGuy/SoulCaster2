class_name MotherSpawnIn extends State

@export var idle_state : State
@export var true_idle_state : State

func enter() -> void:
	parent.animation_player.play("SpawnIn")
	parent.timer.wait_time = 1.0
	parent.timer.start()

func exit() -> void:
	GameManager.just_spawned_mini_round = false

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		if GameManager.just_spawned_mini_round:
			return true_idle_state
		return idle_state
	return null
