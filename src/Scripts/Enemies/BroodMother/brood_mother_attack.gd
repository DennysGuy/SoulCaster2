class_name BroodMotherAttack extends State

@export var idle_state : State

var number_of_times: int = 0
var timer : float = 75
var wait_time : float = 30
func enter() -> void:
	timer = wait_time
	parent.animation_player.play("AttackPrep")
	number_of_times = randi_range(6,14)
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	timer -= 10*_delta
	if timer <= 0:
		parent.animation_player.play("Attack")
		number_of_times -= 1
		print(number_of_times)
		if number_of_times <= 0:
			return idle_state
		else:
			timer = 12
	
	return null
