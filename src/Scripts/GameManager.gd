extends Node

var can_move : bool = true
var can_shoot : bool = false

var in_arena : bool = false
var in_menu : bool = false


var rifle_owned : bool = false
var amulet_owned : bool = false
var enemy_tracker_owned : bool = false

var bullets_left : int = 32
var pistol_magazine_size : int = 1
var rifle_magazine_size : int = 6
var bullets_in_clip : int = 6
var magazine : int = 0

var pistol_mag_cost : int = 5
var rifle_mag_cost: int = 10

var round_number : int = -1
const MAX_ROUND : int = 3

var shots_fired : int = 0
var misses : int = 0
var hits : int = 0
var hits_taken : int = 0
var xp_gained : int = 0
var levels_gained : int = 0
var rounds_beaten : int = 0
var enemies_killed : int = 0
var ore_acquired : int = 0
var round_timers : Array[int] = [8, 7, 7]
var round_times : Array[int] = [125, 230, 340]

var minimum_spawn : Array[int] = [1,1,2]
var maximum_spawn : Array[int] = [2,3,3]

var max_configurations : Dictionary = {
	0: {
		ROUND_POINT.BEGINNING:1,
		ROUND_POINT.FIRST_QUARTER:1,
		ROUND_POINT.HALF_WAY:2,
		ROUND_POINT.THREE_QUARTER:2
	},
	1: {
		ROUND_POINT.BEGINNING:1,
		ROUND_POINT.FIRST_QUARTER:2,
		ROUND_POINT.HALF_WAY:3,
		ROUND_POINT.THREE_QUARTER:4
	},
	2: {
		ROUND_POINT.BEGINNING:2,
		ROUND_POINT.FIRST_QUARTER:3,
		ROUND_POINT.HALF_WAY:3,
		ROUND_POINT.THREE_QUARTER:4
	},
}

func get_max_configs() -> int:
	return max_configurations[round_number][current_round_point]

enum ROUND_POINT {BEGINNING, FIRST_QUARTER, HALF_WAY, THREE_QUARTER}
var current_round_point : ROUND_POINT = ROUND_POINT.BEGINNING

var first_quarter_point : bool = false
var half_way_point : bool = false
var three_quarter_way_point : bool = false

var fortified_pistol_bullets_cost : int = 15
var fortified_pistol_bullets : bool = false

var fortified_pistol_rifle_cost : int = 15
var fortified_rifle_bullets : bool = false

var hub_instructions_shown : bool = false
var arena_instructions_shown : bool = false

var furtherest_round_unlocked : int = 0
var current_round_selected : int = 0


@onready var waves : Dictionary = {
	0 : {
		"starting config amount": 1,
		"stagger_time":1.8,
		"spawn_time":1.4,
		
	}
}

const R_1P_1_ENEMY_CONFIGURATION_1 = preload("uid://5nstlh3c1vsr")
const R_1P_1_ENEMY_CONFIGURATION_2 = preload("uid://hh6c6a7to1wy")
const R_1P_1_ENEMY_CONFIGURATION_3 = preload("uid://ss6xkovx4mvr")
const R_1P_1_ENEMY_CONFIGURATION_4 = preload("uid://bc0e2ym2xy7uw")
const R_1P_1_ENEMY_CONFIGURATION_5 = preload("uid://dpjlq06kweu0g")

const R_1P_2_ENEMY_CONFIGURATION_1 = preload("uid://c83sa8d1a5kg")
const R_1P_2_ENEMY_CONFIGURATION_2 = preload("uid://dy0rb4qusucix")
const R_1P_2_ENEMY_CONFIGURATION_3 = preload("uid://k5hfn51wdr33")
const R_1P_2_ENEMY_CONFIGURATION_4 = preload("uid://bp4sfmvaq1cv1")
const R_1P_2_ENEMY_CONFIGURATION_5 = preload("uid://cnpuuoayxgmav")

const R_1P_3_ENEMY_CONFIGURATION_1 = preload("uid://ct6yat2qoar6h")
const R_1P_3_ENEMY_CONFIGURATION_2 = preload("uid://c0on4cc18bkes")
const R_1P_3_ENEMY_CONFIGURATION_3 = preload("uid://1u305yju4fmd")
const R_1P_3_ENEMY_CONFIGURATION_4 = preload("uid://cneh2fvi0bbmj")
const R_1P_3_ENEMY_CONFIGURATION_5 = preload("uid://clcfvw0enqy1q")

const R_2P_1_ENEMY_CONFIGURATION_1 = preload("uid://bbom6n6fpj5lm")
const R_2P_1_ENEMY_CONFIGURATION_2 = preload("uid://w7idtusl7df4")
const R_2P_1_ENEMY_CONFIGURATION_3 = preload("uid://dx5wdqr25yu44")
const R_2P_1_ENEMY_CONFIGURATION_4 = preload("uid://dtwt31x7nrwj1")
const R_2P_1_ENEMY_CONFIGURATION_5 = preload("uid://8yk3a1qho3wp")

const R_2P_2_ENEMY_CONFIGURATION_1 = preload("uid://d3vcrajedhyd3")
const R_2P_2_ENEMY_CONFIGURATION_2 = preload("uid://cu7iyagdeqg7a")
const R_2P_2_ENEMY_CONFIGURATION_3 = preload("uid://dt4n6rt7lplcu")
const R_2P_2_ENEMY_CONFIGURATION_4 = preload("uid://c6h866t512uk1")
const R_2P_2_ENEMY_CONFIGURATION_5 = preload("uid://ofvw6g23qrho")

const R_2P_3_ENEMY_CONFIGURATION_1 = preload("uid://b6bwyflm0y43j")
const R_2P_3_ENEMY_CONFIGURATION_2 = preload("uid://8xgbl6k4q7j8")
const R_2P_3_ENEMY_CONFIGURATION_3 = preload("uid://7nosaueb6v0m")
const R_2P_3_ENEMY_CONFIGURATION_4 = preload("uid://cp0dpmhyru5jw")
const R_2P_3_ENEMY_CONFIGURATION_5 = preload("uid://ch0tgs47p8iow")

const R_3P_1_ENEMY_CONFIGURATION_1 = preload("uid://ddppxqlbh7kaa")
const R_3P_1_ENEMY_CONFIGURATION_2 = preload("uid://bq7dflqv14d3n")
const R_3P_1_ENEMY_CONFIGURATION_3 = preload("uid://dyb34fjnoo0yv")
const R_3P_1_ENEMY_CONFIGURATION_4 = preload("uid://fq3myvlxlcwn")
const R_3P_1_ENEMY_CONFIGURATION_5 = preload("uid://dknepiwhr4mio")

const R_3P_2_ENEMY_CONFIGURATION_1 = preload("uid://44t47blqhbcc")
const R_3P_2_ENEMY_CONFIGURATION_2 = preload("uid://fhph24u134ia")
const R_3P_2_ENEMY_CONFIGURATION_3 = preload("uid://dqb8q1du7slcp")
const R_3P_2_ENEMY_CONFIGURATION_4 = preload("uid://cnfl5skkh6mud")
const R_3P_2_ENEMY_CONFIGURATION_5 = preload("uid://b5dpwadhee44e")

const R_3P_3_ENEMY_CONFIGURATION_1 = preload("uid://dtmk4snnbv1gf")
const R_3P_3_ENEMY_CONFIGURATION_2 = preload("uid://b60q6a2o6qjhg")
const R_3P_3_ENEMY_CONFIGURATION_3 = preload("uid://bbkcsm3xa7itc")
const R_3P_3_ENEMY_CONFIGURATION_4 = preload("uid://cia5itaa3tfno")
const R_3P_3_ENEMY_CONFIGURATION_5 = preload("uid://bcdxn6h3wo8o5")


func play_sfx(sound: AudioStream, volume: float = 0.0, pitch_scale : float = 1.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

@onready var wave_configurations : Dictionary = {
	0: 
		{ROUND_POINT.BEGINNING:[
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1, "weight": 4},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5, "weight":1}
			],
		ROUND_POINT.FIRST_QUARTER:[
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5, "weight":4}
		],
		ROUND_POINT.HALF_WAY:[
				{"scene": R_1P_2_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_5, "weight":4}
		],
		ROUND_POINT.THREE_QUARTER:[
				{"scene": R_1P_3_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_5, "weight":4}
		],
	},
	1:
		{ROUND_POINT.BEGINNING:[
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1, "weight": 5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2, "weight":4},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5, "weight":1}
			],
		ROUND_POINT.FIRST_QUARTER:[
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5, "weight":4}
		],
		ROUND_POINT.HALF_WAY:[
				{"scene": R_2P_2_ENEMY_CONFIGURATION_1, "weight": 2},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_2, "weight":4},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_4, "weight":5},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_5, "weight":1}
		],
		ROUND_POINT.THREE_QUARTER:[
				{"scene": R_2P_3_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_2, "weight":4},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_5, "weight":1}
		],
	},
	2:
		{ROUND_POINT.BEGINNING:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1, "weight": 3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4, "weight":4},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5, "weight":1}
			],
		ROUND_POINT.FIRST_QUARTER:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5, "weight":4}
		],
		ROUND_POINT.HALF_WAY:[
				{"scene": R_3P_2_ENEMY_CONFIGURATION_1, "weight": 1},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_2, "weight":4},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_3, "weight":3},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_4, "weight":2},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_5, "weight":5}
		],
		ROUND_POINT.THREE_QUARTER:[
				{"scene": R_3P_3_ENEMY_CONFIGURATION_1, "weight": 3},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_2, "weight":5},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_3, "weight":2},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_4, "weight":1},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_5, "weight":3}
		],
	},
}

func pick_weighted_config(config_list: Array) -> PackedScene:
	var total_weight := 0
	for entry in config_list:
		total_weight += entry["weight"]
	
	var roll := randi_range(1, total_weight)
	var cumulative := 0
	
	for entry in config_list:
		cumulative += entry["weight"]
		if roll <= cumulative:
			return entry["scene"]
	
	return null # should never hit if weights are valid
