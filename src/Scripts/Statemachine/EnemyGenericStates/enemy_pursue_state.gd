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
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

	if parent.player:
		var direction: Vector3 = (
			parent.player.global_position - parent.global_position
		).normalized()

		parent.look_at(parent.player.global_position, Vector3.UP)

		if parent.is_on_floor():
			var floor_normal: Vector3 = parent.get_floor_normal()

			# Remove the component of movement going into the floor.
			direction = direction - floor_normal * direction.dot(floor_normal)
			direction = direction.normalized()

			# Move at the desired speed along the slope.
			parent.velocity = direction * parent.selected_move_speed * _delta
		else:
			# Normal movement + gravity while airborne.
			parent.velocity.x = direction.x * parent.selected_move_speed * _delta
			parent.velocity.z = direction.z * parent.selected_move_speed * _delta
			parent.velocity.y -= gravity * _delta

		parent.move_and_slide()

	return null
