class_name Player extends CharacterBody3D

@export var look_at_point_1 : Marker3D
@export var look_at_point_2 : Marker3D
@export var look_at_point_3 : Marker3D
@export var look_at_point_4 : Marker3D
@onready var timer: Timer = $Timer

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var point_at_marker: Marker3D = $Head/PointAtMarker

var target_index : int = 1
var target_location : Marker3D
@onready var look_at_positions : Array[Marker3D] = [look_at_point_3, look_at_point_1, look_at_point_2, look_at_point_4]
@export var aim_box_size: Vector2 = Vector2(200, 200) # how far the reticle can drift from center
@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen

@onready var rifle: Node3D = $Head/Marker3D/GunArm/Rifle
@onready var pistol: Node3D = $Head/Marker3D/GunArm/Pistol

var rotate_speed: float = 5.0  # higher = faster turn
var zoom_target: float = 60.0  # smaller FOV = zoom in
var zoom_speed: float = 5.0    # how fast zoom eases

@onready var gun_arm: Node3D = $Head/Marker3D/GunArm

@onready var cross_hair: CrossHair = $CanvasLayer/CrossHair

@onready var gun_animation_player: AnimationPlayer = $Head/Marker3D/GunArm/Pistol/AnimationPlayer
@onready var rifle_animation_player: AnimationPlayer = $Head/Marker3D/GunArm/Rifle/AnimationPlayer

var initial_player_rotation = Vector3.ZERO
var initial_head_rotation = Vector3.ZERO
var initial_fov: float

var shooting : bool = false
var can_shoot : bool = true

@export var alert_arrow: AlertArrow
@export var alert_arrow_2: AlertArrow
@export var alert_arrow_3: AlertArrow
@export var alert_arrow_4: AlertArrow

const LOOKLEFT = preload("uid://b6dm6bij87ov0")
const LOOKRIGHT = preload("uid://bp6hlgrojy4g6")

const PISTOL_1 = preload("uid://d3bilne8hioau")
const PISTOL_2 = preload("uid://d0vf5y2x0n20t")
const PISTOL_3 = preload("uid://srtq7jkoqrnk")

const RIFLE_1 = preload("uid://cu7votcgtdpnw")
const RIFLE_2 = preload("uid://gliv55qaccva")
const RIFLE_3 = preload("uid://canubute4csy8")
const RIFLE_4 = preload("uid://cqfjqpj2kkt8v")

const PISTOLRELOAD = preload("uid://lhw7fod3087e")


@onready var pistol_sfx : Array[AudioStream] = [PISTOL_1,PISTOL_2,PISTOL_3]
@onready var rifle_sfx : Array[AudioStream] = [RIFLE_1,RIFLE_2,RIFLE_3,RIFLE_4]

var chosen_gun_animation_player : AnimationPlayer

var enemy_alerts: Array = [] 
var enemy_list : Array[Enemy] = []

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
	SignalBus.enemy_spawned.connect(notify_enemy)
	SignalBus.face_boss_area.connect(face_boss_spawn_area)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	camera.make_current()
	target_location = look_at_positions[target_index]
	initial_player_rotation = rotation
	initial_head_rotation = head.rotation
	initial_fov = camera.fov
	rotate_speed = PlayerStats.player_stats["Movement Speed"]
	
	if GameManager.rifle_owned:
		rifle.show()
		pistol.hide()
		chosen_gun_animation_player = rifle_animation_player 
		GameManager.magazine = GameManager.rifle_magazine_size
	else:
		pistol.show()
		rifle.hide()
		chosen_gun_animation_player = gun_animation_player
		GameManager.magazine = GameManager.pistol_magazine_size
		
	GameManager.bullets_in_clip = GameManager.magazine
	alert_arrow_4.visible = false
	alert_arrow_3.visible = false
	alert_arrow.visible = false
	alert_arrow_2.visible = false

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GameManager.amulet_owned:
		_update_arrows()
	
	if GameManager.can_move:
		if Input.is_action_pressed("shoot") and !shooting and GameManager.in_arena:
			if GameManager.bullets_in_clip <= 0:
				shooting = true
				GameManager.play_sfx(PISTOLRELOAD)
				play_reload_animation()
			else:
				shooting = true
				GameManager.bullets_in_clip -= 1
				SignalBus.bullet_fired.emit()
				play_shoot_animation()
		
		if Input.is_action_just_pressed("reload") and GameManager.in_arena:
			shooting = true
			GameManager.play_sfx(PISTOLRELOAD)
			play_reload_animation()
		
		move_player()
	
	move_arm()


func _physics_process(delta: float) -> void:
	move_camera(delta)

func move_player() -> void:
	if Input.is_action_just_pressed("rotate_left"):
		#AudioManager.play_sfx(AudioManager.LOOKLEFT,-2)
		print("Rotate Left")
		GameManager.play_sfx(LOOKLEFT,-4)
		rotate_camera_left()

	if Input.is_action_just_pressed("rotate_right"):
		#AudioManager.play_sfx(AudioManager.LOOKRIGHT,-2)
		print("Rotate Right")
		GameManager.play_sfx(LOOKRIGHT,-4)
		rotate_camera_right()
		
	if Input.is_action_just_pressed("rotate_opposite"):
		#AudioManager.play_sfx(AudioManager.LOOKLEFT, -2)
		print("Rotate Behind")
		GameManager.play_sfx(LOOKRIGHT,-4)
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
	var attack_speed : float = PlayerStats.player_stats["Attack Speed"]
	if GameManager.rifle_owned:
		chosen_gun_animation_player.speed_scale = attack_speed+0.5
		GameManager.play_sfx(rifle_sfx.pick_random())
	else:
		GameManager.play_sfx(pistol_sfx.pick_random())
		chosen_gun_animation_player.speed_scale = attack_speed
	#GameManager.ammo_count -= 1
	#SignalBus.update_ammo_count.emit()
	chosen_gun_animation_player.play("SHOOT")
	var body_part = shoot_ray()
	shoot_enemy(body_part)
	SignalBus.shot_fired.emit()
	SignalBus.shake_camera.emit(0.5)
	#if GameManager.ammo_count <= 0 and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		#GameManager.can_shoot = false
		##SignalBus.show_reload_notification.emit()
	#else:
		#await get_tree().create_timer(0.15).timeout
		#GameManager.can_shoot = true
		
	await chosen_gun_animation_player.animation_finished
	shooting = false
	#GameManager.can_shoot = true

func shoot_enemy(enemy_body_part : Node3D):
	var enemy
	print("BANG!")
	if enemy_body_part:
		enemy = enemy_body_part.get_parent()
	if enemy_body_part and enemy is Enemy or enemy_body_part and enemy is TestOre or enemy_body_part and enemy is BabyBullet:
		#if not enemy.is_boss:
			#GameManager.total_shots_hit += 1
			#SignalBus.increment_hits_count.emit()
		var seen_enemy = enemy_body_part.get_parent()

		if enemy_body_part is EnemyBodyCollider and enemy is Enemy and seen_enemy.can_hurt:
			seen_enemy.damage_enemy()
		elif enemy_body_part is HeadCollider and enemy is Enemy and seen_enemy.can_hurt:
			seen_enemy.head_shot_kill()
		elif enemy_body_part is OreCollider:
			seen_enemy.damage_ore()
		elif enemy_body_part is EnemyBodyCollider and enemy is BabyBullet:
			enemy.die()
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


func _update_arrows() -> void:
	# Hide all arrows at start
	alert_arrow_4.visible = false
	alert_arrow_3.visible = false
	alert_arrow.visible = false
	alert_arrow_2.visible = false

	var dir_shown = {"front": false, "back": false, "left": false, "right": false}
	var quadrant_counts = {"front": 0, "back": 0, "left": 0, "right": 0}
	
	#var facing = _get_facing_quadrant()
	
	# Count enemies per quadrant
	for enemy in enemy_list:
		if not is_instance_valid(enemy) or not enemy.alive:
			enemy_alerts.erase(enemy)
			continue

		var q = _get_enemy_quadrant(enemy)
		#print("Im facing here: " + facing + " Enemy is located here: " + q)
		
		# Remove enemies if player is facing that quadrant
		if _is_facing_quadrant(q):
			#print("but I dropped in here...")
			enemy_alerts.erase(enemy)
			#direction_teller.hide()
			continue

		quadrant_counts[q] += 1

		# Show arrow once per quadrant
		#print(q)
		match q:
			"front": 
				alert_arrow_4.visible = true
			"back": 
				alert_arrow_3.visible = true
			"left": 
				alert_arrow.visible = true
			"right": 
				alert_arrow_2.visible = true
	
		dir_shown[q] = true


func notify_enemy(enemy: Node3D) -> void:
	#print("Enemy spawned in quadrant: ", _get_enemy_quadrant(enemy))
	#if enemy not in enemy_alerts:
	enemy_alerts.append(enemy)
	enemy_list.append(enemy)


func _get_enemy_quadrant(enemy: Node3D) -> String:
	var to_enemy = (enemy.global_transform.origin - global_transform.origin).normalized()

	# Transform into player's local space
	var local_dir = global_transform.basis.inverse() * to_enemy

	# Get angle of enemy in local XZ plane
	var angle = atan2(local_dir.x, -local_dir.z) # radians, relative to forward (-Z)

	# Snap to quadrant
	if abs(angle) <= PI / 4:
		return "front"
	elif angle > PI / 4 and angle < 3 * PI / 4:
		return "right"
	elif angle < -PI / 4 and angle > -3 * PI / 4:
		return "left"
	else:
		return "back"

func _get_facing_quadrant() -> String:
	var forward = -camera.global_transform.basis.z
	if abs(forward.x) > abs(forward.z):
		return "right" if forward.x > 0 else "left"
	else:
		return "front" if forward.z < 0 else "back"

func _is_facing_quadrant(enemy_quadrant: String) -> bool:
	var forward = -camera.global_transform.basis.z.normalized()

	var local_dir := Vector3.ZERO
	match enemy_quadrant:
		"front": local_dir = Vector3.FORWARD
		"right": local_dir = Vector3.RIGHT
		"back": local_dir = Vector3.BACK
		"left": local_dir = Vector3.LEFT

	# convert local quadrant dir to world space
	var world_dir = global_transform.basis * local_dir
	world_dir = world_dir.normalized()

	# dot product now makes sense: forward (world) vs quadrant (world)
	var dot = forward.dot(world_dir)
	return dot > cos(deg_to_rad(20))  # ~0.94

func play_reload_animation() -> void:
	chosen_gun_animation_player.speed_scale = PlayerStats.player_stats["Reload Speed"]
	chosen_gun_animation_player.play("RELOAD")
	await chosen_gun_animation_player.animation_finished
	GameManager.bullets_in_clip = GameManager.magazine
	SignalBus.bullet_fired.emit()
	shooting = false


func face_boss_spawn_area() -> void:
	target_location = look_at_point_1
	GameManager.can_move = false
