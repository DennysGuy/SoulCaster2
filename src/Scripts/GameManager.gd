extends Node

var can_move : bool = true
var can_shoot : bool = false
var can_hurt_player : bool = true

var in_arena : bool = false
var in_menu : bool = false
var round_started : bool = false

var rifle_owned : bool = false
var amulet_owned : bool = false
var enemy_tracker_owned : bool = false

var mini_round_started : bool = false
var boss_was_stunned : bool = false
var boss_in_roll_mode : bool = false

var bullets_left : int = 32
var pistol_magazine_size : int = 1
var rifle_magazine_size : int = 6
var bullets_in_clip : int = 6
var magazine : int = 0
var just_spawned_mini_round : bool = false
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
var round_timers : Array[int] = [3, 2, 1]
var round_times : Array[int] = [125, 230, 340]

var minimum_spawn : Array[int] = [1,1,2]
var maximum_spawn : Array[int] = [2,3,3]

var max_boss_health : int = 3500
var current_boss_health : int = 3500

var max_boss_stun : int = 600
var current_boss_stun : int = 0

var max_configurations : Dictionary = {
	0: {
		ROUND_POINT.BEGINNING:1,
		ROUND_POINT.FIRST_QUARTER:2,
		ROUND_POINT.HALF_WAY:2,
		ROUND_POINT.THREE_QUARTER:3
	},
	1: {
		ROUND_POINT.BEGINNING:2,
		ROUND_POINT.FIRST_QUARTER:3,
		ROUND_POINT.HALF_WAY:3,
		ROUND_POINT.THREE_QUARTER:4
	},
	2: {
		ROUND_POINT.BEGINNING:2,
		ROUND_POINT.FIRST_QUARTER:3,
		ROUND_POINT.HALF_WAY:4,
		ROUND_POINT.THREE_QUARTER:4
	},
}

func get_max_configs() -> int:
	if GameManager.round_number >= 3 and !GameManager.mini_round_started:
		return 0
	if GameManager.mini_round_started:
		if GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.7):
			GameManager.round_number = 0
			current_round_point = ROUND_POINT.FIRST_QUARTER
		elif GameManager.current_boss_health >= round(GameManager.max_boss_health * 0.3) and GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.7):
			GameManager.round_number = 1
			current_round_point = ROUND_POINT.HALF_WAY
		elif GameManager.current_boss_health <= round(GameManager.max_boss_health * 0.3):
			GameManager.round_number = 2
			current_round_point = ROUND_POINT.THREE_QUARTER
	return max_configurations[round_number][current_round_point]

enum ROUND_POINT {BEGINNING, FIRST_QUARTER, HALF_WAY, THREE_QUARTER}
var current_round_point : ROUND_POINT = ROUND_POINT.BEGINNING

var first_quarter_point : bool = false
var half_way_point : bool = false
var three_quarter_way_point : bool = false

var fortified_pistol_bullets_cost : int = 15
var fortified_pistol_bullets : bool = false

var fortified_pistol_rifle_cost : int = 20
var fortified_rifle_bullets : bool = false

var hub_instructions_shown : bool = false
var arena_instructions_shown : bool = false

var furtherest_round_unlocked : int = 0
var current_round_selected : int = 0

var basic_grenade_cost : int = 8

var grenades_owned : int = 0

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

const R_1P_1_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://5nstlh3c1vsr")
const R_1P_1_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://vf8wmny5y2ap")
const R_1P_1_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://b8mghdfp5ww6h")
const R_1P_1_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://b45hfd0f1lffo")
const R_1P_1_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://cc08nsct88lro")

const R_1P_1_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://bawjyd3f6xm6")
const R_1P_1_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://dlx1nom71yvdp")
const R_1P_1_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://ci5qvchyc4y80")
const R_1P_1_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://ck8qwpf02m3qn")
const R_1P_1_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://dm71ggn7ucicp")

const R_1P_1_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://dgfkd0xu3ielj")
const R_1P_1_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://bs5gs5jyxkaxi")
const R_1P_1_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://crn0r86y8xqsq")
const R_1P_1_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://dyvnvfigm87dq")
const R_1P_1_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://cjc7oy2qwnxi0")

const R_1P_1_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://b3oc6m7b0nfun")
const R_1P_1_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://bdq4o2kyq6ee7")
const R_1P_1_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://t4inqlutjehv")
const R_1P_1_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://dip1ilf82lvso")
const R_1P_1_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://duwwtjem4l1fy")

const R_1P_2_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://dcav36cvpfk1u")
const R_1P_2_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://dc2nctxbkihxa")
const R_1P_2_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://bkrgdciigy7oe")
const R_1P_2_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://b7sas1iy84lkf")
const R_1P_2_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://dh4bf6ksslah")

const R_1P_2_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://cotpb0dnbvfim")
const R_1P_2_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://t4gwnweudvnd")
const R_1P_2_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://ckv7u5gy1bdw1")
const R_1P_2_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://coxkcaj4r70k3")
const R_1P_2_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://cvn1xvu0hqt68")

const R_1P_2_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://bhkq08uvmmcv8")
const R_1P_2_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://dvfyobxomlows")
const R_1P_2_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://cqfj85a8m5mox")
const R_1P_2_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://drg653sqc1rhi")
const R_1P_2_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://d3vbhcpse6awp")

const R_1P_2_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://bahf0wh6kybs7")
const R_1P_2_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://g24kibuv1ohp")
const R_1P_2_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://fgelubuvo3xo")
const R_1P_2_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://s66h8jweqexc")
const R_1P_2_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://d286gtfrmxgay")

const R_1P_3_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://dw2hf0lyriwjm")
const R_1P_3_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://dvjh8b5omudjf")
const R_1P_3_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://bcr3u40yfv5ml")
const R_1P_3_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://lhxw7ltdp0lq")
const R_1P_3_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://dpch7pwrjmpk1")

const R_1P_3_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://bekvbfkpg7qtv")
const R_1P_3_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://cqpnspun1vl4s")
const R_1P_3_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://rba3t1mwiwc2")
const R_1P_3_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://hnp8504atf5j")
const R_1P_3_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://cu4eq8b4vq6re")

const R_1P_3_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://chmf88bkexagk")
const R_1P_3_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://danunn08apybp")
const R_1P_3_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://dg1r0farrgw8n")
const R_1P_3_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://dxcopx4yydc1d")
const R_1P_3_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://bfps1jw6nbeps")

const R_1P_3_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://c82wh5rhos22e")
const R_1P_3_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://b2jat466nbv4f")
const R_1P_3_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://dcsno16wr4ess")
const R_1P_3_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://bi8eprunntg7a")
const R_1P_3_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://b72detlkcrxv7")

const R_2P_1_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://cl5pp12u7gox8")
const R_2P_1_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://crokupuahf6ju")
const R_2P_1_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://y8d57gvq0jvp")
const R_2P_1_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://crfwk40xeeghe")
const R_2P_1_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://vhkmtatrqdys")

const R_2P_1_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://bmmq3o0i5if6v")
const R_2P_1_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://dq6b84shlyloe")
const R_2P_1_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://26ahgiwbk5v2")
const R_2P_1_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://bwch58ce8rqyv")
const R_2P_1_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://c58butls0glqx")

const R_2P_1_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://ctbk8rvyyyrcu")
const R_2P_1_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://w3uvwmn8fi0j")
const R_2P_1_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://dhc6fs83gqylr")
const R_2P_1_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://coi8kw5mikb6q")
const R_2P_1_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://b00wf4awjtr7b")

const R_2P_1_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://bgio7msl258wk")
const R_2P_1_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://dfctjm6r1jtv1")
const R_2P_1_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://b4s8w7vsrkv")
const R_2P_1_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://ckj3nnx4hxh4b")
const R_2P_1_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://dn6gfggbt0q07")

const R_2P_2_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://cp045j5jw7l4g")
const R_2P_2_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://dmpupibm1ma7r")
const R_2P_2_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://b2ahichpfevo3")
const R_2P_2_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://cq28mxju18gdr")
const R_2P_2_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://yy1vbacedopm")

const R_2P_2_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://b12b4sxoalc2o")
const R_2P_2_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://bgap11gij0c04")
const R_2P_2_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://dnwagohlbr8r")
const R_2P_2_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://b3fatn18l114g")
const R_2P_2_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://dhin7nbs42g3h")

const R_2P_2_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://bcnotnd3arvjr")
const R_2P_2_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://dlet17wc3mti2")
const R_2P_2_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://de7hot8vtl8b5")
const R_2P_2_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://dab5oauj5oeae")
const R_2P_2_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://vyys401ssrx1")

const R_2P_2_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://dlq7x55x1gsle")
const R_2P_2_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://f1d8rpuu332b")
const R_2P_2_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://bbwdom3awtutk")
const R_2P_2_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://6bkam14vk3mf")
const R_2P_2_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://bj67wfgdl3uia")

const R_2P_3_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://c4jv3ufxf3ns2")
const R_2P_3_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://gxhtm171u604")
const R_2P_3_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://dhv5kk518jbt6")
const R_2P_3_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://b653ttuj438id")
const R_2P_3_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://bkopepmi6p06l")

const R_2P_3_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://8y5rk788lxlk")
const R_2P_3_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://3m86nm71f3rd")
const R_2P_3_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://d0yp4psyh4a6g")
const R_2P_3_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://hbgf7gm5vbg5")
const R_2P_3_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://cwgxy3xhyd7x6")

const R_2P_3_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://c7ltddft3cksb")
const R_2P_3_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://n4guvur63p0g")
const R_2P_3_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://box2rs0sq1de8")
const R_2P_3_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://bq6c3p10knail")
const R_2P_3_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://ccpm8jvm44k34")

const R_2P_3_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://b25s3h6d6c2pb")
const R_2P_3_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://3xb6jnhb6bqa")
const R_2P_3_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://c37xjwq2bcauw")
const R_2P_3_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://c475r05ccpc0m")
const R_2P_3_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://bvd03ggmhsjp")

const R_3P_1_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://bilwqk64euqe8")
const R_3P_1_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://bpbwlcnfqckac")
const R_3P_1_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://5jqdmy07l7d0")
const R_3P_1_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://515jjar0ve83")
const R_3P_1_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://br6j7mb4uvum")

const R_3P_1_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://cspffm04pxbg1")
const R_3P_1_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://dig28qgx0gdol")
const R_3P_1_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://r1rv60higbs")
const R_3P_1_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://cqjye0gthl80n")
const R_3P_1_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://4abfmf783sm6")

const R_3P_1_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://lak0u5m55grn")
const R_3P_1_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://bbnqjjk0n1qfe")
const R_3P_1_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://w57orx0pejbl")
const R_3P_1_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://cmm7xshj3hv8x")
const R_3P_1_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://nob4ik76arc8")

const R_3P_1_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://bfk0j53lfqkoh")
const R_3P_1_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://lmdt8lh7wyor")
const R_3P_1_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://cfg5y56lhdycr")
const R_3P_1_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://vx08omwcxw0y")
const R_3P_1_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://b7wlxco71cw22")

const R_3P_2_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://dwj5qdftxevy5")
const R_3P_2_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://blja3dn4ymcof")
const R_3P_2_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://b7bt7artfhgbu")
const R_3P_2_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://b8t7lnf5nbrug")
const R_3P_2_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://ctadaky8jgci8")

const R_3P_2_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://ecmrxanlva6c")
const R_3P_2_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://8v35toinjyhx")
const R_3P_2_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://1ra8nf0s6p7c")
const R_3P_2_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://cwktb81pewinr")
const R_3P_2_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://1pi8ps5yq4vn")

const R_3P_2_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://cdyyo35x0equ2")
const R_3P_2_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://1xjvjfd7svql")
const R_3P_2_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://d1snbs0hgtw2l")
const R_3P_2_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://wm7nggp17ty6")
const R_3P_2_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://c6cdc41j2rrdy")

const R_3P_2_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://dcu3ruu323jek")
const R_3P_2_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://btlebkpl0r68s")
const R_3P_2_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://bmv70hfoh8gvm")
const R_3P_2_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://cu0e61484pywd")
const R_3P_2_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://cpg8or4rgjxqq")

const R_3P_3_ENEMY_CONFIGURATION_1_POINT_1 = preload("uid://ce87h6qd8c0ey")
const R_3P_3_ENEMY_CONFIGURATION_2_POINT_1 = preload("uid://drp87pdse2bbe")
const R_3P_3_ENEMY_CONFIGURATION_3_POINT_1 = preload("uid://sivyk7ahqibd")
const R_3P_3_ENEMY_CONFIGURATION_4_POINT_1 = preload("uid://b0omxmp11ewue")
const R_3P_3_ENEMY_CONFIGURATION_5_POINT_1 = preload("uid://cuyd8y4l14oj4")

const R_3P_3_ENEMY_CONFIGURATION_1_POINT_2 = preload("uid://dhbm4wa2el18i")
const R_3P_3_ENEMY_CONFIGURATION_2_POINT_2 = preload("uid://c78ha3mr6gebq")
const R_3P_3_ENEMY_CONFIGURATION_3_POINT_2 = preload("uid://b481wbk214j60")
const R_3P_3_ENEMY_CONFIGURATION_4_POINT_2 = preload("uid://dyc6s4esi6dyx")
const R_3P_3_ENEMY_CONFIGURATION_5_POINT_2 = preload("uid://b1hk8w2qch30d")

const R_3P_3_ENEMY_CONFIGURATION_1_POINT_3 = preload("uid://cxietxksgnrvm")
const R_3P_3_ENEMY_CONFIGURATION_2_POINT_3 = preload("uid://dj871edg7q340")
const R_3P_3_ENEMY_CONFIGURATION_3_POINT_3 = preload("uid://db5cd58cbcbwi")
const R_3P_3_ENEMY_CONFIGURATION_4_POINT_3 = preload("uid://daoun3ywjmxx0")
const R_3P_3_ENEMY_CONFIGURATION_5_POINT_3 = preload("uid://chgodoe3ny3hs")

const R_3P_3_ENEMY_CONFIGURATION_1_POINT_4 = preload("uid://cbgg57shmcs02")
const R_3P_3_ENEMY_CONFIGURATION_2_POINT_4 = preload("uid://bg6iimsipbfvu")
const R_3P_3_ENEMY_CONFIGURATION_3_POINT_4 = preload("uid://b6e18ki0vmi72")
const R_3P_3_ENEMY_CONFIGURATION_4_POINT_4 = preload("uid://j0efxdtq1otp")
const R_3P_3_ENEMY_CONFIGURATION_5_POINT_4 = preload("uid://be8krdngpvapf")


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
		{ROUND_POINT.BEGINNING: {
			0: [
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 4},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":1}
			],
			1:[
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 4},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":1}
			],
			2:[
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 4},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":1}
			],
			3:[
				{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 4},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":2},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":3},
				{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":1}
			],
		}
			,
		ROUND_POINT.FIRST_QUARTER: { 
		0:[
			{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":4}
		], 
		1: [
			{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":4}
		],
		2: [
			{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":4}
		],
		3: [
			{"scene": R_1P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
			{"scene":R_1P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":4}
		],
		}
		,
		ROUND_POINT.HALF_WAY:{
			0: [
				{"scene": R_1P_2_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_5_POINT_1, "weight":4}
			],
			1: [
				{"scene": R_1P_2_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_5_POINT_2, "weight":4}
			],
			2: [
				{"scene": R_1P_2_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_5_POINT_3, "weight":4}
			],
			3: [
				{"scene": R_1P_2_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_1P_2_ENEMY_CONFIGURATION_5_POINT_4, "weight":4}
			],
		},
		ROUND_POINT.THREE_QUARTER:{
			0: [
				{"scene": R_1P_3_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_5_POINT_1, "weight":4}
			],
			1:[
				{"scene": R_1P_3_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_5_POINT_2, "weight":4}
			],
			2:[
				{"scene": R_1P_3_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_5_POINT_3, "weight":4}
			],
			3:[
				{"scene": R_1P_3_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_1P_3_ENEMY_CONFIGURATION_5_POINT_4, "weight":4}
			],
		},
	},
	1:
		{ROUND_POINT.BEGINNING: {
			0: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":4},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":1}
			],
			1: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":4},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":1}
			],
			2:[
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":4},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":1}
			],
			3: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":4},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":1}
			]
		},
		ROUND_POINT.FIRST_QUARTER:{
			0: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":4}
			],
			1: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":4}
			],
			2: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":4}
			],
			3: [
				{"scene": R_2P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_2P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":4}
			],
		},
		ROUND_POINT.HALF_WAY:{
			0: [
				{"scene": R_2P_2_ENEMY_CONFIGURATION_1_POINT_1, "weight": 2},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_2_POINT_1, "weight":4},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_4_POINT_1, "weight":5},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_5_POINT_1, "weight":1}
			],
			1:[
				{"scene": R_2P_2_ENEMY_CONFIGURATION_1_POINT_2, "weight": 2},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_2_POINT_2, "weight":4},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_4_POINT_2, "weight":5},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_5_POINT_2, "weight":1}
			],
			2:[
				{"scene": R_2P_2_ENEMY_CONFIGURATION_1_POINT_3, "weight": 2},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_2_POINT_3, "weight":4},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_4_POINT_3, "weight":5},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_5_POINT_3, "weight":1}
			],
			3:[
				{"scene": R_2P_2_ENEMY_CONFIGURATION_1_POINT_4, "weight": 2},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_2_POINT_4, "weight":4},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_4_POINT_4, "weight":5},
				{"scene":R_2P_2_ENEMY_CONFIGURATION_5_POINT_4, "weight":1}
			],
		},
		ROUND_POINT.THREE_QUARTER:{
			0:[
				{"scene": R_2P_3_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_2_POINT_1, "weight":4},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_5_POINT_1, "weight":1}
			],
			1:[
				{"scene": R_2P_3_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_2_POINT_2, "weight":4},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_5_POINT_2, "weight":1}
			],
			2:[
				{"scene": R_2P_3_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_2_POINT_3, "weight":4},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_5_POINT_3, "weight":1}
			],
			3:[
				{"scene": R_2P_3_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_2_POINT_4, "weight":4},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_2P_3_ENEMY_CONFIGURATION_5_POINT_4, "weight":1}
			]
		}
	},
	2:
		{ROUND_POINT.BEGINNING:{0: [
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":4},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":1}
			],
			1:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":4},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":1}
			],
			2:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":4},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":1}
			],
			3:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":4},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":1}
			],
		},
		ROUND_POINT.FIRST_QUARTER:{
			0: [
				{"scene":R_3P_1_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_1, "weight":4}
			],
			1:[
				{"scene":R_3P_1_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_2, "weight":4}
			],
			2:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_3, "weight":4}
			],
			3:[
				{"scene": R_3P_1_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_3P_1_ENEMY_CONFIGURATION_5_POINT_4, "weight":4}
			],
		},
		ROUND_POINT.HALF_WAY:{
			0:[
				{"scene": R_3P_2_ENEMY_CONFIGURATION_1_POINT_1, "weight": 1},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_2_POINT_1, "weight":4},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_3_POINT_1, "weight":3},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_4_POINT_1, "weight":2},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_5_POINT_1, "weight":5}
			],
			1:[
				{"scene": R_3P_2_ENEMY_CONFIGURATION_1_POINT_2, "weight": 1},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_2_POINT_2, "weight":4},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_3_POINT_2, "weight":3},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_4_POINT_2, "weight":2},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_5_POINT_2, "weight":5}
			],
			2:[
				{"scene": R_3P_2_ENEMY_CONFIGURATION_1_POINT_3, "weight": 1},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_2_POINT_3, "weight":4},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_3_POINT_3, "weight":3},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_4_POINT_3, "weight":2},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_5_POINT_3, "weight":5}
			],
			3:[
				{"scene": R_3P_2_ENEMY_CONFIGURATION_1_POINT_4, "weight": 1},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_2_POINT_4, "weight":4},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_3_POINT_4, "weight":3},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_4_POINT_4, "weight":2},
				{"scene":R_3P_2_ENEMY_CONFIGURATION_5_POINT_4, "weight":5}
			],
		},
		ROUND_POINT.THREE_QUARTER: {
			0:[
				{"scene": R_3P_3_ENEMY_CONFIGURATION_1_POINT_1, "weight": 3},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_2_POINT_1, "weight":5},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_3_POINT_1, "weight":2},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_4_POINT_1, "weight":1},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_5_POINT_1, "weight":3}
			],
			1:[
				{"scene": R_3P_3_ENEMY_CONFIGURATION_1_POINT_2, "weight": 3},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_2_POINT_2, "weight":5},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_3_POINT_2, "weight":2},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_4_POINT_2, "weight":1},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_5_POINT_2, "weight":3}
			],
			2:[
				{"scene": R_3P_3_ENEMY_CONFIGURATION_1_POINT_3, "weight": 3},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_2_POINT_3, "weight":5},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_3_POINT_3, "weight":2},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_4_POINT_3, "weight":1},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_5_POINT_3, "weight":3}
			],
			3:[
				{"scene": R_3P_3_ENEMY_CONFIGURATION_1_POINT_4, "weight": 3},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_2_POINT_4, "weight":5},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_3_POINT_4, "weight":2},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_4_POINT_4, "weight":1},
				{"scene":R_3P_3_ENEMY_CONFIGURATION_5_POINT_4, "weight":3}
			],
		},
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
