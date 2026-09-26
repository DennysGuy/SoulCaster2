class_name RollOver extends State

@export var idle_state : State
@export var jump_left : State
@export var jump_right : State
@export var jump_center : State

@onready var jump_states : Array[State] = [jump_left, jump_right, jump_center]

func enter() -> void:
	parent.animation_player.play("RollOver")
	parent.timer.wait_time = 3.0
	parent.timer.start()

func exit() -> void:
	GameManager.boss_in_roll_mode = false

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		var chosen : bool = random_number(70)
		if chosen:
			return pick_random_position()
		
		return idle_state
	
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
