class_name Enemy extends CharacterBody3D

var player : Player
var prev_state : State
#var arena : Arena
@export var animation_player : AnimationPlayer
@export var damage_label_position : Marker3D

@export_group("Enemy Stats")
@export var move_speed  : float = 40
@export var health : int = 3
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

var alive : bool = true
var can_hurt : bool = true
func _ready() -> void:
	pass

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
	
	var chosen_state : State = hurt_states.pick_random()
	state_machine.change_state(chosen_state)
	var damage : int = randi_range(int(PlayerStats.player_stats["Attack Damage"]-2), int(PlayerStats.player_stats["Attack Damage"]+2))
	
	var is_crit : bool = calculate_crit()
	if is_crit:
		damage *= PlayerStats.player_stats["Crit Damage"]
	
	spawn_damage_label(damage, is_crit)
	health -= damage
	if health <= 0:
		kill_enemy()


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
