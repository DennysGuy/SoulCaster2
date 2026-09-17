class_name Enemy extends CharacterBody3D

var player : Player
var prev_state : State
#var arena : Arena
@export var animation_player : AnimationPlayer
@export var damage_label_position : Marker3D
@export var blood_spout : Marker3D
@export var skeleton : Skeleton3D
@export var arrow_hits : Array[Node3D]
@export var bolt_position : Marker3D
@export var lock_on_target : Sprite3D
@export var leap_player : AudioStreamPlayer3D

@export_group("Enemy Stats")
@export var enemy_name : String
@export var move_speed  : float = 40
@export var health : int = 3
@export var max_enemy_health : int
@export var attack_damage : int = 0
@export var progress_amount : float
@export var xp : int = 0
@export var base_score : int
@export var grunt_death_pitch : float
@export var consumable_spawn_point : Marker3D
@export var hit_stop_time : float = 0.2

@export var body_flash_point : Marker3D
@export var head_flash_point : Marker3D

@export_group("Damage States")
@export var dead_state : State
@export var attack_state : State
@export var hurt_1_state : State
@export var hurt_2_state : State
@export var head_shot_dead : State
@export var reflect_state : State

@onready var state_machine : StateMachine = $StateMachine
@onready var hurt_states : Array[State] = [hurt_1_state, hurt_2_state]

const RAT_DEATH_1 = preload("uid://d3ghyfjmncx5c")

@export var hurt_1 : AudioStream
@export var hurt_2 : AudioStream
@export var hurt_3 : AudioStream

@onready var hurts : Array[AudioStream] = [hurt_1,hurt_2,hurt_3]

const RAT_LEAP_1 = preload("uid://c7gf702jnbls2")
const RAT_LEAP_2 = preload("uid://cf6dtnrcoij5i")
const RAT_LEAP_3 = preload("uid://by242hcdg8ma4")

@onready var leaps : Array[AudioStream] = [RAT_LEAP_1,RAT_LEAP_2,RAT_LEAP_3]


var round_ended : bool = false

var alive : bool = true
var can_hurt : bool = true

@onready var selected_move_speed : float = move_speed
var selected_speed_scale : float = 0.7
@onready var move_speeds : Dictionary = {
	0 : [move_speed, 0.7],
	1 : [selected_move_speed+20,1.0],
	2 : [selected_move_speed+35,1.3]
}

func _ready() -> void:
	SignalBus.round_ended.connect(kill_enemy)
	SignalBus.enemy_hit.connect(hide_lock_on_target)
	var rand_num : int = randi_range(0,100)
	var selected_value : int = select_speed(rand_num)
	selected_move_speed = move_speeds[selected_value][0]
	selected_speed_scale = move_speeds[selected_value][1]

func _process(delta: float) -> void:
	if !player:
		player = get_tree().get_first_node_in_group("Player")

func kill_enemy(ended_round : bool = false) -> void:
	if not alive:
		return
		
	alive = false
	if lock_on_target:
		lock_on_target.hide()
	if ended_round:
		round_ended = true
	
	state_machine.change_state(dead_state)

func head_shot_kill() -> void:
	if not alive:
		return
		
	alive = false
	
	state_machine.change_state(head_shot_dead)

func damage_enemy() -> void:
	if not alive:	
		return
	
	if hurt_1_state:
		state_machine.change_state(hurt_1_state)
		
	var damage : int = randi_range(int(PlayerStats.player_stats["Attack Damage"]-2), int(PlayerStats.player_stats["Attack Damage"]+2))
	
	var is_crit : bool = calculate_crit()
	if is_crit:
		damage *= PlayerStats.player_stats["Crit Damage"]
		
	if GameManager.rifle_owned:
		damage += 10
	
	if blood_spout:
		spawn_blood_spirt()
	if skeleton:
		hit_flash()
	
	if !arrow_hits.is_empty():
		var rand_num : int = randi_range(0,arrow_hits.size())
		var bolt : Node3D = arrow_hits.get(rand_num)
		if bolt:
			bolt.show()
		arrow_hits.remove_at(rand_num)
	
	show_lock_on_target()
	SignalBus.enemy_hit.emit(self)
	spawn_damage_label(damage, is_crit)
	health -= damage
	
	if self is BroodMother:
		SignalBus.boss_damaged.emit(health, max_enemy_health)
	else:
		SignalBus.enemy_found.emit(enemy_name, health, max_enemy_health)
	if health <= 0:
		kill_enemy()
		GameManager.play_sfx(RAT_DEATH_1)
	else:
		GameManager.play_sfx(hurts.pick_random())

func spawn_damage_label(damage : int, is_crit : bool) -> void:
	var damage_label : DamageLabel = preload("uid://blcs0f2y7cia2").instantiate()
	damage_label.label.text = str(damage)
	damage_label.position = damage_label_position.position
	if is_crit:
		damage_label.set_bg_as_crit()
	
	add_child(damage_label)

func calculate_crit() -> bool:
	var rand_num : int = randi_range(0,100)
	var crit_chance : int = int(PlayerStats.player_stats["Crit Chance"] * 100)
	
	if rand_num <= crit_chance:
		return true
	
	return false

func attack_player() -> void:
	if !GameManager.can_hurt_player:
		return
	
	SignalBus.player_hurt.emit(attack_damage)
	SignalBus.shake_camera.emit(1.0)
	SignalBus.player_damaged.emit()


func spawn_blood_spirt() -> void:
	var blood_spirt : BloodSpirt = preload("uid://e2pwh1u4lv32").instantiate()
	blood_spout.add_child(blood_spirt)

func hit_flash() -> void:
	for child in skeleton.get_children():
		if child is BoneAttachment3D:
			continue
		var mesh: MeshInstance3D = child
		var base_mat: Material = mesh.get_active_material(0)
		var flash_mat: ShaderMaterial = base_mat.next_pass

		flash_mat.set("shader_parameter/flash", 1.0)

	await get_tree().create_timer(0.1).timeout

	for child in skeleton.get_children():
		if child is BoneAttachment3D:
			continue
		var mesh: MeshInstance3D = child
		var base_mat: Material = mesh.get_active_material(0)
		var flash_mat: ShaderMaterial = base_mat.next_pass

		flash_mat.set("shader_parameter/flash", 0.0)

func make_materials_unique(node: Node):
	if node is MeshInstance3D and node.mesh:
		for i in node.mesh.get_surface_count():
			var material = node.get_active_material(i)

			if material is ShaderMaterial:
				node.set_surface_override_material(i, material.duplicate())

	for child in node.get_children():
		make_materials_unique(child)

func select_speed(value : int) -> int:
	if value <= 15:
		return 2
	elif value <= 30:
		return 1
	else:
		return 0

func show_lock_on_target() -> void:
	if lock_on_target:
		lock_on_target.show()

func hide_lock_on_target(target : Node3D) -> void:
	if target == self:
		return
	
	if lock_on_target:
		lock_on_target.hide()

func play_leap() -> void:
	leap_player.stream = leaps.pick_random()
	leap_player.play()
