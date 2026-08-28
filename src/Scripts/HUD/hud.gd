class_name HUD extends CanvasLayer

@onready var round_timer: Timer = $RoundTimer
@onready var timer_label: Label = $RoundTimerTitle/TimerLabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level: Label = $ProgressBar/Level
@onready var xp: Label = $ProgressBar/XP

@onready var enemy_tracker: Panel = $EnemyTracker
@onready var enemy_name: Label = $EnemyTracker/EnemyName
@onready var enemy_hp: ProgressBar = $EnemyTracker/EnemyHP

@onready var ore_count_label: Label = $OreCountLabel

@onready var bullets_tracker: Label = $BulletsTracker

const XP_MULTIPLIER_FACTOR : float = 1.2
const BASE_XP_AMOUNT : int = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.xp_was_gained.connect(add_xp)
	SignalBus.player_damaged.connect(flash_screen_red)
	SignalBus.ore_gathered.connect(update_ore_count_label)
	SignalBus.enemy_found.connect(update_enemy_tracker)
	SignalBus.bullet_fired.connect(update_bullets_tracker)
	update_ore_count_label()
	#round_timer.wait_time = PlayerStats.player_stats["Starting Timer"]
	#round_timer.start()
	update_level()
	if GameManager.enemy_tracker_owned:
		enemy_tracker.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


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
	
func flash_screen_red() -> void:
	animation_player.play("HurtFlash")

func update_ore_count_label() -> void:
	ore_count_label.text = str(int(PlayerStats.player_stats["Ore"]))

func update_enemy_tracker(enemy_name : String, enemy_health : int, enemy_max_health : int) -> void:
	self.enemy_name.text = enemy_name
	enemy_hp.max_value = enemy_max_health
	enemy_hp.value = enemy_health

func update_bullets_tracker() -> void:
	bullets_tracker.text = "%s/%s" % [GameManager.bullets_in_clip, GameManager.bullets_left]
