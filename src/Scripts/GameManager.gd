extends Node

var can_move : bool = true
var can_shoot : bool = false

var in_arena : bool = false
var in_menu : bool = false


var rifle_owned : bool = false
var amulet_owned : bool = false
var enemy_tracker_owned : bool = false

var bullets_left : int = 32
var pistol_magazine_size : int = 6
var rifle_magazine_size : int = 12
var bullets_in_clip : int = 6
var magazine : int = 0

var pistol_mag_cost : int = 5
var rifle_mag_cost: int = 10

var round_number : int = -1
const MAX_ROUND : int = 3

var round_timers : Array[int] = [9, 8, 7]
var round_times : Array[int] = [100, 150, 200]

var minimum_spawn : Array[int] = [1,1,2]
var maximum_spawn : Array[int] = [2,2,3]

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

func play_sfx(sound: AudioStream, volume: float = 0.0, pitch_scale : float = 1.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
