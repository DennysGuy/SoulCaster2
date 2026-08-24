class_name Player extends CharacterBody3D

@export var look_at_point_1 : Marker3D
@export var look_at_point_2 : Marker3D
@export var look_at_point_3 : Marker3D
@export var look_at_point_4 : Marker3D
@onready var timer: Timer = $Timer

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

var target_index : int = 1
var target_location : Marker3D
@onready var look_at_positions : Array[Marker3D] = [look_at_point_3, look_at_point_1, look_at_point_2, look_at_point_4]
@export var aim_box_size: Vector2 = Vector2(200, 200) # how far the reticle can drift from center
@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen

var rotate_speed: float = 10.0  # higher = faster turn
var zoom_target: float = 60.0  # smaller FOV = zoom in
var zoom_speed: float = 5.0    # how fast zoom eases

@onready var gun_arm: Node3D = $Head/Marker3D/GunArm

@onready var cross_hair: CrossHair = $CanvasLayer/CrossHair

@onready var gun_animation_player: AnimationPlayer = $Head/Marker3D/GunArm/Pistol/AnimationPlayer

var initial_player_rotation = Vector3.ZERO
var initial_head_rotation = Vector3.ZERO
var initial_fov: float

var shooting : bool = false

@onready var look_at_points : Dictionary[String,Marker3D] = {
	"point 1" : look_at_point_1,
	"point 2" : look_at_point_2,
	"point 3" : look_at_point_3,
	"point 4" : look_at_point_4,
}

var reticle_offset := Vector2(-90,0)
const SENSITIVITY := 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	camera.make_current()
	target_location = look_at_positions[target_index]
	initial_player_rotation = rotation
	initial_head_rotation = head.rotation
	initial_fov = camera.fov
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("shoot") and !shooting:
		shooting = true
		play_shoot_animation()
	
	move_arm()
	move_player()

func _physics_process(delta: float) -> void:
	move_camera(delta)

func move_player() -> void:
	if Input.is_action_just_pressed("rotate_left"):
		#AudioManager.play_sfx(AudioManager.LOOKLEFT,-2)
		print("Rotate Left")
		rotate_camera_left()

	if Input.is_action_just_pressed("rotate_right"):
		#AudioManager.play_sfx(AudioManager.LOOKRIGHT,-2)
		print("Rotate Right")
		rotate_camera_right()
		
	if Input.is_action_just_pressed("rotate_opposite"):
		#AudioManager.play_sfx(AudioManager.LOOKLEFT, -2)
		print("Rotate Behind")
		rotate_camera_opposite()
		
	#if GameManager.can_move:
		#if Input.is_action_just_pressed("swap_pistol") and GameManager.equipped_weapon == GameManager.WEAPONS.RIFLE:
			#swap_to_pistol()
		#
		#if Input.is_action_just_pressed("swap_rifle") and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL\
			#and GameManager.rifle_ammo_count > 0 and GameManager.rifle_unlocked:
				#swap_to_rifle()
		#
		#if Input.is_action_just_pressed("toss_grenade") and GameManager.can_throw_grenade:
			#GameManager.grenade_uses += 1
			#SignalBus.issue_grenade.emit()
		#
			#
	#if Input.is_action_just_pressed("reload") and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		#GameManager.can_shoot = false
		#play_reload_animation()
		#SignalBus.reload_pistol.emit()
	

func rotate_camera_left() -> void:
	target_index -= 1
		
	if target_index < 0:
		target_index = 3
			
	target_location = look_at_positions[target_index]

func rotate_camera_right() -> void:
	target_index += 1
		
	if target_index > look_at_positions.size()-1:
		target_index = 0
			
	target_location = look_at_positions[target_index]

func rotate_camera_opposite() -> void:
	if target_index == look_at_positions.size()-1:
		target_index = 1
	elif target_index == 0:
		target_index = 2
	else:
		target_index += 2
		if target_index == look_at_positions.size():
			target_index = 0
			
	target_location = look_at_positions[target_index]


func move_camera(_delta: float) -> void:
	if target_location:
		var target_pos = target_location.global_transform.origin
		var my_pos = global_transform.origin

		# --- Compute desired yaw to target ---
		var to_target = (target_pos - my_pos).normalized()
		to_target.y = 0.0
		var target_yaw = atan2(-to_target.x, -to_target.z)

		# --- Snap yaw to nearest cardinal direction ---
		var snapped_yaw = round(target_yaw / (PI / 2.0)) * (PI / 2.0)

		# --- Smoothly rotate player to snapped direction with easing ---
		var yaw_diff = wrapf(snapped_yaw - rotation.y, -PI, PI)
		var t = 1.0 - pow(0.5, _delta * rotate_speed)  # smooth exponential easing
		rotation.y += yaw_diff * t

		# Optional: snap instantly if very close to target to avoid tiny jitters
		#if abs(yaw_diff) < deg_to_rad(1.0):
			#rotation.y = snapped_yaw

		# --- Smooth pitch (head tilt) ---
		var head_to_target = (target_pos - head.global_transform.origin).normalized()
		var target_pitch = -asin(head_to_target.y)
		head.rotation.x = lerp_angle(head.rotation.x, target_pitch, _delta * rotate_speed)

		# --- Smooth zoom ---
		camera.fov = lerp(camera.fov, zoom_target, _delta * zoom_speed)
	else:
		# Ease back to initial rotation and FOV when no target
		rotation.y = lerp_angle(rotation.y, initial_player_rotation.y, _delta * rotate_speed)
		head.rotation.x = lerp_angle(head.rotation.x, initial_head_rotation.x, _delta * rotate_speed)
		camera.fov = lerp(camera.fov, initial_fov, _delta * zoom_speed)


func move_arm() -> void:
	var screen_center = get_viewport().get_visible_rect().size * 0.5
	var mouse_pos = get_viewport().get_mouse_position()
	# Move the crosshair UI anywhere on the screen
	cross_hair.position = mouse_pos
	
	# Calculate gun arm target (clamped)
	var screen_offset = mouse_pos - screen_center
	var clamped_offset = Vector2(
		clamp(screen_offset.x, -max_arm_offset.x, max_arm_offset.x),
		clamp(screen_offset.y, -max_arm_offset.y, max_arm_offset.y)
	)
	var arm_screen_pos = screen_center + clamped_offset

	# Build ray from camera through clamped arm position
	var from = camera.project_ray_origin(arm_screen_pos)
	var to = from + camera.project_ray_normal(arm_screen_pos) * 1000

	# Make the gun arm look at clamped target
	gun_arm.look_at(to, Vector3.UP)
	var x_rot = clamp(gun_arm.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	gun_arm.rotation = Vector3(x_rot, gun_arm.rotation.y, gun_arm.rotation.z)

func show_reticle() -> void:
	cross_hair.show()

func hide_reticle() -> void:
	cross_hair.hide()

func play_shoot_animation() -> void:
	#gun_animation_player.speed_scale = 3.5
	#GameManager.ammo_count -= 1
	#SignalBus.update_ammo_count.emit()
	gun_animation_player.play("SHOOT")
	var body_part = shoot_ray()
	shoot_enemy(body_part)
	##SignalBus.shake_camera.emit(0.4)
	#if GameManager.ammo_count <= 0 and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		#GameManager.can_shoot = false
		##SignalBus.show_reload_notification.emit()
	#else:
		#await get_tree().create_timer(0.15).timeout
		#GameManager.can_shoot = true
		
	await get_tree().create_timer(0.583).timeout
	shooting = false
	#GameManager.can_shoot = true

func shoot_enemy(enemy_body_part : Node3D):
	var enemy
	print("BANG!")
	if enemy_body_part:
		enemy = enemy_body_part.get_parent()
	if enemy_body_part and enemy is Enemy or enemy_body_part and enemy is TestOre:
		#if not enemy.is_boss:
			#GameManager.total_shots_hit += 1
			#SignalBus.increment_hits_count.emit()
		var seen_enemy = enemy_body_part.get_parent()

		if enemy_body_part is EnemyBodyCollider:
			seen_enemy.damage_enemy()
		elif enemy_body_part is HeadCollider:
			seen_enemy.head_shot_kill()
		elif enemy_body_part is OreCollider:
			seen_enemy.damage_ore()
	#else:
		#SignalBus.reset_hits_count.emit()
	
	#GameManager.total_shots += 1	

func get_aim_ray() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	return to

func shoot_ray() -> Node3D:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 15000

	var space_state = get_world_3d().direct_space_state
	
	# Create ray query and set collision mask to layer 6
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1 << 5  # layer 6 (layers are 0-indexed)
	
	var result = space_state.intersect_ray(query)

	#print(result)
	if result:
		return result["collider"]
	else:
		print("damned")
		#SignalBus.reset_combo_meter.emit()
	return null


func look_at_target(target : Marker3D, zoom : float) -> void:
	zoom_target = zoom
	target_location = target
