class_name EnemyPursueState extends State

const CHANCE_TO_BE_SASSY : int = 30


func enter() -> void:

	parent.animation_player.speed_scale = parent.selected_speed_scale
	
	parent.play_walk_animation("Run")

func exit() -> void:
	parent.animation_player.speed_scale = 1.0


func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.player:
		var direction : Vector3 = (parent.player.global_transform.origin - parent.global_transform.origin).normalized()
		parent.velocity = direction * parent.selected_move_speed * _delta
		parent.look_at(parent.player.global_transform.origin, Vector3.UP)
		parent.move_and_slide()
	
	return null
