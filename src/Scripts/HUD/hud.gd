class_name HUD extends CanvasLayer

@onready var round_timer: Timer = $RoundTimer
@onready var timer_label: Label = $RoundTimerTitle/TimerLabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level: Label = $ProgressBar/Level
@onready var xp: Label = $ProgressBar/XP

const XP_MULTIPLIER_FACTOR : float = 1.2
const BASE_XP_AMOUNT : int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.xp_was_gained.connect(add_xp)
	SignalBus.time_added.connect(add_time)
	SignalBus.player_hurt.connect(reduce_time)
	round_timer.wait_time = PlayerStats.player_stats["Starting Timer"]
	round_timer.start()
	update_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	timer_label.text = str(int(round_timer.time_left))

func _on_round_timer_timeout() -> void:
	get_tree().change_scene_to_file("uid://jgsciuanachx")

func update_level() -> void:
	level.text = "Level: %s" % int(PlayerStats.player_stats["Level"])
	xp.text = "[%s/%s]" % [int(PlayerStats.player_stats["Current XP"]), int(PlayerStats.player_stats["Needed XP"])]
	progress_bar.value = int(PlayerStats.player_stats["Current XP"])
	progress_bar.max_value = int(PlayerStats.player_stats["Needed XP"])

func level_up() -> void:
	PlayerStats.player_stats["Level"] += 1
	PlayerStats.player_stats["Current XP"] = abs(int(PlayerStats.player_stats["Current XP"] - PlayerStats.player_stats["Needed XP"]))
	PlayerStats.player_stats["Needed XP"] = int(BASE_XP_AMOUNT * pow(XP_MULTIPLIER_FACTOR, PlayerStats.player_stats["Level"]))
	PlayerStats.player_stats["Ability Points"] += 1
	update_level()

func add_xp(amount : int) -> void:
	PlayerStats.player_stats["Current XP"] += amount
	
	progress_bar.value = PlayerStats.player_stats["Current XP"]
	update_level()
	
	if PlayerStats.player_stats["Current XP"] >= PlayerStats.player_stats["Needed XP"]:
		level_up()
	
	
func add_time(amount : int) -> void:
	round_timer.wait_time += amount
	round_timer.start()

func reduce_time(amount) -> void:
	round_timer.wait_time -= amount
	round_timer.start()
