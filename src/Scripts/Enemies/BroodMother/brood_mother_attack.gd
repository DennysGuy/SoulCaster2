class_name BroodMotherAttack extends State

@export var idle_state : State

var number_of_times: int = 0
var timer : float = 75
var wait_time : float = 75
func enter() -> void:
	parent.animation_player.play("AttackPrep")
	number_of_times = randi_range(3,5)
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	timer -= 20*_delta
	print(timer)
	if timer <= 0:
		parent.animation_player.play("Attack")
		number_of_times -= 1
		if number_of_times <= 0:
			return idle_state
		else:
			timer = 10
	
	return null
