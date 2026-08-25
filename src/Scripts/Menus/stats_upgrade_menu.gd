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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_damage_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_attack_speed_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_movement_speed_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_crit_chance_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_crit_damage_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_starting_timer_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_defense_level_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_ore_spawn_time_upgrade_button_button_up() -> void:
	pass # Replace with function body.


func _on_reload_speed_upgrade_button_button_up() -> void:
	pass # Replace with function body.
