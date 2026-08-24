class_name OreHurt extends State

@export var idle_state : State

func enter() -> void:
	parent.animation_player.play(animation_name)
	parent.timer.wait_time = 0.4
	parent.health -= 1

func exit() -> void:
	if parent.health <= 0:
		parent.queue_free()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		return idle_state
	
	return null
