extends Node

var can_move : bool = false
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
const MAX_ROUND : int = 2

var round_timers : Array[int] = [8, 7, 6]
var round_times : Array[int] = [100, 150, 200]

var minimum_spawn : Array[int] = [1,1,1]
var maximum_spawn : Array[int] = [2,2,3]
