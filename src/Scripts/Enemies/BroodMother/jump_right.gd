class_name JumpRight extends State

@export var attack_state : State
@export var roll_prep_state : State
@export var jump_up_state : State
const BOSS_MOVE_RIGHT = preload("uid://1k1c7yu2mdog")

func enter() -> void:
	#parent.animation_player.play(animation_name)
	parent.cur_position = parent.CURRENT_POSITION.RIGHT
	var tween : Tween = create_tween()
	var final_position : Vector3 = parent.established_position - parent.global_transform.basis.x * 5
	tween.tween_property(parent, "global_position", final_position, 0.4)
	parent.timer.wait_time = 1.0
	GameManager.play_sfx(BOSS_MOVE_RIGHT)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		var chance : bool = random_number(30)
		if chance:
			return roll_prep_state
		return attack_state
	
	return null
		
func random_number(chance : int) -> bool:
	var rand_int : int = randi_range(0,100)
	if rand_int <= chance:
		return true
	
	return false
