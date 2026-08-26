class_name StatsUpgradeMenu extends Control

@onready var attack_damage_level: Label = $StatsUpgradePanel/GridContainer/AttackDamageLevel
@onready var attack_speed_level: Label = $StatsUpgradePanel/GridContainer/AttackSpeedLevel
@onready var movement_speed_level: Label = $StatsUpgradePanel/GridContainer/MovementSpeedLevel
@onready var crit_chance_level: Label = $StatsUpgradePanel/GridContainer/CritChanceLevel
@onready var crit_damage_level: Label = $StatsUpgradePanel/GridContainer/CritDamageLevel
@onready var starting_timer_level: Label = $StatsUpgradePanel/GridContainer/StartingTimerLevel
@onready var defense_level: Label = $StatsUpgradePanel/GridContainer/DefenseLevel
@onready var ore_spawn_time_level: Label = $StatsUpgradePanel/GridContainer/OreSpawnTimeLevel
@onready var reload_speed_level: Label = $StatsUpgradePanel/GridContainer/ReloadSpeedLevel

@onready var attack_damage_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/AttackDamageUpgradeButton
@onready var attack_speed_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/AttackSpeedUpgradeButton
@onready var movement_speed_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/MovementSpeedUpgradeButton
@onready var crit_chance_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/CritChanceUpgradeButton
@onready var crit_damage_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/CritDamageUpgradeButton
@onready var starting_timer_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/StartingTimerUpgradeButton
@onready var defense_level_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/DefenseLevelUpgradeButton
@onready var ore_spawn_time_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/OreSpawnTimeUpgradeButton
@onready var reload_speed_upgrade_button: Button = $StatsUpgradePanel/VBoxContainer/ReloadSpeedUpgradeButton

@onready var upgrade_buttons : Array[Button] = [attack_damage_upgrade_button, attack_speed_upgrade_button, movement_speed_upgrade_button, crit_chance_upgrade_button, crit_damage_upgrade_button, starting_timer_upgrade_button, defense_level_upgrade_button, ore_spawn_time_upgrade_button, reload_speed_upgrade_button]
@onready var stats: Label = $StatsPanel/Stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	init_upgrades()
	update_stats_description()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_attack_damage_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Attack Damage"] += PlayerStats.stat_levels["Attack Damage"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Attack Damage"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_attack_speed_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Attack Speed"] += PlayerStats.stat_levels["Attack Speed"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Attack Speed"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_movement_speed_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Movement Speed"] += PlayerStats.stat_levels["Movement Speed"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Movement Speed"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_crit_chance_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Crit Chance"] += PlayerStats.stat_levels["Crit Chance"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Crit Chance"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_crit_damage_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Crit Damage"] += PlayerStats.stat_levels["Crit Damage"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Crit Damage"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_starting_timer_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Starting Timer"] += PlayerStats.stat_levels["Starting Timer"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Starting Timer"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_defense_level_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Defense"] += PlayerStats.stat_levels["Defense"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Defense"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_ore_spawn_time_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Ore Spawn Time"] += PlayerStats.stat_levels["Ore Spawn Time"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Ore Spawn Time"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func _on_reload_speed_upgrade_button_button_up() -> void:
	PlayerStats.player_stats["Reload Speed"] += PlayerStats.stat_levels["Reload Speed"]["Interval"]
	PlayerStats.player_stats["Ability Points"] -= 1
	PlayerStats.stat_levels["Reload Speed"]["Level"] += 1
	init_upgrades()
	update_stats_description()

func init_upgrades() -> void:
	attack_damage_level.text = "Attack Damage Level: %s/%s" % [PlayerStats.stat_levels["Attack Damage"]["Level"], PlayerStats.stat_levels["Attack Damage"]["Max Level"]]
	attack_speed_level.text = "Attack Speed Level: %s/%s" % [PlayerStats.stat_levels["Attack Speed"]["Level"], PlayerStats.stat_levels["Attack Speed"]["Max Level"]]
	movement_speed_level.text = "Movement Speed Level: %s/%s" % [PlayerStats.stat_levels["Movement Speed"]["Level"], PlayerStats.stat_levels["Movement Speed"]["Max Level"]]
	crit_chance_level.text = "Crit Chance Level: %s/%s" % [PlayerStats.stat_levels["Crit Chance"]["Level"], PlayerStats.stat_levels["Crit Chance"]["Max Level"]]
	crit_damage_level.text = "Crit Damage Level: %s/%s" % [PlayerStats.stat_levels["Crit Damage"]["Level"], PlayerStats.stat_levels["Crit Damage"]["Max Level"]]
	starting_timer_level.text = "Starting Timer Level: %s/%s" % [PlayerStats.stat_levels["Starting Timer"]["Level"], PlayerStats.stat_levels["Starting Timer"]["Max Level"]]
	defense_level.text = "Defense Level: %s/%s" % [PlayerStats.stat_levels["Defense"]["Level"], PlayerStats.stat_levels["Defense"]["Max Level"]]
	ore_spawn_time_level.text = "Ore Spawn Time Level: %s/%s" % [PlayerStats.stat_levels["Ore Spawn Time"]["Level"], PlayerStats.stat_levels["Ore Spawn Time"]["Max Level"]]
	reload_speed_level.text = "Reload Speed Level: %s/%s" % [PlayerStats.stat_levels["Reload Speed"]["Level"], PlayerStats.stat_levels["Reload Speed"]["Max Level"]]

	if PlayerStats.player_stats["Ability Points"] <= 0:
		for button in upgrade_buttons:
			button.disabled =  true
	else:
		for button in upgrade_buttons:
			button.disabled = false


func update_stats_description() -> void:
	stats.text = """
	Attack Damage: %s
	Attack Speed: %s %%
	Movement Speed: %s
	Crit Chance: %s %%
	Crit Damage: %s %%
	Starting Timer: %s
	Defense: %s %%
	Ore Spawn Time: %s
	Reload Speed: %s %%
	""" % [
		PlayerStats.player_stats["Attack Damage"],
		int(PlayerStats.player_stats["Attack Speed"] * 100),
		int(PlayerStats.player_stats["Movement Speed"]),
		int(PlayerStats.player_stats["Crit Chance"] * 100),
		int(PlayerStats.player_stats["Crit Damage"] * 100),
		PlayerStats.player_stats["Starting Timer"],
		int(PlayerStats.player_stats["Defense"] * 100),
		PlayerStats.player_stats["Ore Spawn Time"],
		int(PlayerStats.player_stats["Reload Speed"] * 100)
	]


func _on_button_button_up() -> void:
	GameManager.in_menu = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()
