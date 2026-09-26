class_name BroodMotherTrueIdle extends State

var timer : float = 100
@export var attack_state : State
@export var jump_up_state : State
@export var roll_prep_state : State

@export var jump_left : State
@export var jump_right : State
@export var jump_center : State

@onready var jump_states : Array[State] = [jump_left, jump_right, jump_center]

func enter() -> void:
	parent.animation_player.play("Idle")
	if GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.7):
		timer = randf_range(40.0,60.0)
	elif GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.3) and GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.7):
		timer = randf_range(30.0,50.0)
	elif GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.3):
		timer = randf_range(20.0,40.0)
	
func exit() -> void:
	GameManager.boss_was_stunned = false

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	
	timer -= 20 * _delta
	if timer <= 0:
		if GameManager.boss_was_stunned:
			return jump_up_state
			
		return pick_random_position()
	
	return null

func process_physics(_delta: float) -> State:
	return null


func random_number(chance : int) -> bool:
	var rand_int : int = randi_range(0,100)
	if rand_int <= chance:
		return true
	
	return false

	
	
func pick_random_position() -> State:
	var jump : State = null
	jump_states.shuffle()
	for pos in jump_states:
		if parent.cur_position == parent.CURRENT_POSITION.CENTER and pos is JumpCenter:
			continue
		if parent.cur_position == parent.CURRENT_POSITION.LEFT and pos is JumpLeft:
			continue
		if parent.cur_position == parent.CURRENT_POSITION.RIGHT and pos is JumpRight:
			continue
		jump = pos
		break
		
	return jump
