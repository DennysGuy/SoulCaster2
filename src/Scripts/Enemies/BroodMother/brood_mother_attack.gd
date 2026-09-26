class_name BroodMotherAttack extends State

@export var idle_state : State

@export var jump_left : State
@export var jump_right : State
@export var jump_center : State

@onready var jump_states : Array[State] = [jump_left, jump_right, jump_center]
const BOSS_PREP = preload("uid://cimkiq3bm7ncq")

var number_of_times: int = 0
var timer : float = 75
var wait_time : float = 12
func enter() -> void:
	timer = wait_time
	GameManager.play_sfx(BOSS_PREP)
	parent.animation_player.play("AttackPrep")
	if GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.7):
		number_of_times = randi_range(3,5)
	elif GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.3) and GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.7):
		number_of_times = randi_range(2,4)
	elif GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.3):
		number_of_times = randi_range(2,3)
	
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
			
			var chosen : bool = random_number(70)
			if chosen:
				return pick_random_position()
		
			return idle_state
		else:
			timer = 12
	
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
