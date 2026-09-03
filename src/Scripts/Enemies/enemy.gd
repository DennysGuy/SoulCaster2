class_name Enemy extends CharacterBody3D

var player : Player
var prev_state : State
#var arena : Arena
@export var animation_player : AnimationPlayer
@export var damage_label_position : Marker3D
@export var blood_spout : Marker3D
@export var skeleton : Skeleton3D

@export_group("Enemy Stats")
@export var enemy_name : String
@export var move_speed  : float = 40
@export var health : int = 3
@export var max_enemy_health : int
@export var attack_damage : int = 0
@export var xp : int = 0
@export var base_score : int
@export var grunt_death_pitch : float
@export var consumable_spawn_point : Marker3D

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

var alive : bool = true
var can_hurt : bool = true
func _ready() -> void:
	#if skeleton:
		#for child in skeleton.get_children():
			#var mesh: MeshInstance3D = child
			#var base_mat: Material = mesh.get_active_material(0)
#
			#if base_mat and base_mat.next_pass:
				#base_mat.next_pass = base_mat.next_pass.duplicate()
	SignalBus.round_ended.connect(kill_enemy)

func _process(delta: float) -> void:
	if !player:
		player = get_tree().get_first_node_in_group("Player")

func kill_enemy(killed_by_grenade : bool = false) -> void:
	if not alive:
		return
		
	alive = false

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
	SignalBus.player_hurt.emit(attack_damage)
	SignalBus.shake_camera.emit(1.0)
	SignalBus.player_damaged.emit()

func spawn_blood_spirt() -> void:
	var blood_spirt : BloodSpirt = preload("uid://e2pwh1u4lv32").instantiate()
	blood_spout.add_child(blood_spirt)

func hit_flash() -> void:
	for child in skeleton.get_children():
		var mesh: MeshInstance3D = child
		var base_mat: Material = mesh.get_active_material(0)
		var flash_mat: ShaderMaterial = base_mat.next_pass

		flash_mat.set("shader_parameter/flash", 1.0)

	await get_tree().create_timer(0.1).timeout

	for child in skeleton.get_children():
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
