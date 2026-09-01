class_name HUD extends CanvasLayer

@onready var round_timer: Timer = $RoundTimer
@onready var timer_label: Label = $RoundTimerTitle/TimerLabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level: Label = $ProgressBar/Level
@onready var xp: Label = $ProgressBar/XP

@onready var xp_gained_position: Marker2D = $XPGainedPosition
@onready var time_gained_position: Marker2D = $TimeGainedPosition
@onready var ore_gained_position: Marker2D = $OreGainedPosition

@onready var enemy_tracker: Panel = $EnemyTracker
@onready var enemy_name: Label = $EnemyTracker/EnemyName
@onready var enemy_hp: ProgressBar = $EnemyTracker/EnemyHP

@onready var ore_count_label: Label = $OreCountLabel

@onready var bullets_tracker: Label = $BulletsTracker

@onready var round_diamond_container: HBoxContainer = $RoundDiamondContainer

@onready var round_timer_label: WaveTimerLabel = $RoundTimerLabel

const BOSS_STYLE = preload("uid://dw6lx7qdi3qjd")
const ROUND_STYLE = preload("uid://5eyxyvcgpq2q")


const XP_MULTIPLIER_FACTOR : float = 1.2
const BASE_XP_AMOUNT : int = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var round_started : bool = false
var round_ended : bool = false
@onready var round_progress_bar: ProgressBar = $RoundProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.xp_was_gained.connect(add_xp)
	SignalBus.time_added.connect(add_time_label)
	SignalBus.progress_added.connect(add_progress)
	SignalBus.player_damaged.connect(flash_screen_red)
	SignalBus.ore_gathered.connect(update_ore_count_label)
	SignalBus.enemy_found.connect(update_enemy_tracker)
	SignalBus.bullet_fired.connect(update_bullets_tracker)
	SignalBus.player_hurt.connect(decrease_time_label)
	update_ore_count_label(0)
	#round_timer.wait_time = PlayerStats.player_stats["Starting Timer"]
	#round_timer.start()
	update_level()
	if GameManager.enemy_tracker_owned:
		enemy_tracker.show()
		
	if GameManager.rifle_owned:
		GameManager.magazine = GameManager.rifle_magazine_size
	else:
		GameManager.magazine = GameManager.pistol_magazine_size
	
	GameManager.round_number += 1
	animation_player.play("RoundCountDown")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if round_started:
		if Input.is_action_just_pressed("jump") and GameManager.round_number < GameManager.MAX_ROUND:
			round_progress_bar.value = round_progress_bar.max_value - 2
		
		if round_progress_bar.value < round_progress_bar.max_value:
			round_progress_bar.value += delta
			
			if !GameManager.half_way_point and round_progress_bar.value >= int(round_progress_bar.max_value * 0.5):
				GameManager.current_round_point = GameManager.ROUND_POINT.HALF_WAY
				GameManager.half_way_point = true
			
			elif !GameManager.three_quarter_way_point and round_progress_bar.value >= int(round_progress_bar.max_value * 0.75):
				GameManager.current_round_point = GameManager.ROUND_POINT.THREE_QUARTER
				GameManager.three_quarter_way_point = true
		else:
			if GameManager.round_number < GameManager.MAX_ROUND and !round_ended:
				SignalBus.round_ended.emit()
				end_round()

				

func update_level() -> void:
	level.text = "Level: %s" % int(PlayerStats.player_stats["Level"])
	xp.text = "[%s/%s]" % [int(PlayerStats.player_stats["Current XP"]), int(PlayerStats.player_stats["Needed XP"])]
	progress_bar.value = int(PlayerStats.player_stats["Current XP"])
	progress_bar.max_value = int(PlayerStats.player_stats["Needed XP"])

func level_up() -> void:
	PlayerStats.player_stats["Level"] += 1
	PlayerStats.player_stats["Current XP"] = abs(int(PlayerStats.player_stats["Current XP"] - PlayerStats.player_stats["Needed XP"]))
	PlayerStats.player_stats["Needed XP"] = int(BASE_XP_AMOUNT * pow(XP_MULTIPLIER_FACTOR, PlayerStats.player_stats["Level"]))
	PlayerStats.player_stats["Ability Points"] += PlayerStats.player_stats["AP Amount"]
	update_level()

func add_xp(amount : int) -> void:
	PlayerStats.player_stats["Current XP"] += amount
	add_xp_label(amount)
	progress_bar.value = PlayerStats.player_stats["Current XP"]
	update_level()
	
	if PlayerStats.player_stats["Current XP"] >= PlayerStats.player_stats["Needed XP"]:
		level_up()
	
func flash_screen_red() -> void:
	animation_player.play("HurtFlash")
	

func update_ore_count_label(amount : int) -> void:
	ore_count_label.text = str(int(PlayerStats.player_stats["Ore"]))
	if amount > 0:
		var ore_gathered_lable : ReceivedLabel = preload("uid://ca2bgl0v774sj").instantiate()
		ore_gathered_lable.label.text = "+%sore" % amount
		ore_gained_position.add_child(ore_gathered_lable)
		

func update_enemy_tracker(enemy_name : String, enemy_health : int, enemy_max_health : int) -> void:
	self.enemy_name.text = enemy_name
	enemy_hp.max_value = enemy_max_health
	enemy_hp.value = enemy_health

func update_bullets_tracker() -> void:
	bullets_tracker.text = "%s/%s" % [GameManager.bullets_in_clip, GameManager.magazine]

func start_round() -> void:		
	round_ended = false
	round_started = true
	
	GameManager.half_way_point = false
	GameManager.three_quarter_way_point = false
	GameManager.current_round_point = GameManager.ROUND_POINT.BEGINNING
	
	round_timer_label.timer_started = true
	round_progress_bar.value = 0
	round_progress_bar.max_value = GameManager.round_times[GameManager.round_number]
	SignalBus.round_started.emit()

func load_timer() -> void:
	round_timer_label.reset_timer()

func end_round() -> void:
	round_ended = true
	round_started = false
	round_timer_label.timer_started = false
	round_progress_bar.value = 0
	if GameManager.round_number > -1:
		var round_diamond : RoundDiamond = round_diamond_container.get_child(GameManager.round_number)
		round_diamond.fill_diamond()
	
	GameManager.round_number += 1	
	if GameManager.round_number < GameManager.MAX_ROUND:
		animation_player.play("RoundCountDown")
	else:
		start_boss_fight()
	
func kill_all_enemies() -> void:
	SignalBus.round_ended.emit()

func add_xp_label(amount : int) -> void:
	var xp_label : ReceivedLabel = preload("uid://ca2bgl0v774sj").instantiate()
	xp_label.label.text = "+%sxp" % amount
	xp_gained_position.add_child(xp_label)

func add_time_label(amount : int) -> void:
	var time_label : ReceivedLabel = preload("uid://ca2bgl0v774sj").instantiate()
	time_label.label.text = "+%ssec." % amount
	time_gained_position.add_child(time_label)

func decrease_time_label(amount : int) -> void:
	var time_label : ReceivedLabel = preload("uid://ca2bgl0v774sj").instantiate()
	time_label.label.text = "-%ssec." % amount
	time_gained_position.add_child(time_label)
	
func add_progress() -> void:
	progress_bar.value += PlayerStats.player_stats["Progress Speed"]

func start_boss_fight() -> void:
	round_timer_label.zero_out_timer()
	SignalBus.face_boss_area.emit()
	await get_tree().create_timer(2.0).timeout
	SignalBus.boss_fight_started.emit()
	await get_tree().create_timer(2.0).timeout
	fill_boss_bar()
	round_timer_label.set_time(90,0)
	animation_player.play("BossCountDown")
	
func fill_boss_bar() -> void:
	round_progress_bar.add_theme_stylebox_override("fill", BOSS_STYLE)
	round_progress_bar.max_value = 800
	var tween : Tween = create_tween()
	await tween.tween_property(round_progress_bar, "value", round_progress_bar.max_value, 3.0).finished

func start_fight() -> void:
	GameManager.can_move = true
	round_timer_label.start_timer()
	SignalBus.combat_engaged.emit()
