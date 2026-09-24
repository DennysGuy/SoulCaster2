class_name BroodMotherTrueIdle extends State

var timer : float = 100
@export var attack_state : State
@export var jump_up_state : State
@export var roll_prep_state : State

func enter() -> void:
	parent.animation_player.play("Idle")
	timer = randf_range(40.0,60.0)

func exit() -> void:
	GameManager.boss_was_stunned = false

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	
	timer -= 20 * _delta
	if timer <= 0:
		
		if GameManager.boss_was_stunned:
			return jump_up_state
		
		var chance : bool = random_number(30)
		if chance:
			return roll_prep_state
		return attack_state
	
	return null

func process_physics(_delta: float) -> State:
	return null


func random_number(chance : int) -> bool:
	var rand_int : int = randi_range(0,100)
	if rand_int <= chance:
		return true
	
	return false
	
	
