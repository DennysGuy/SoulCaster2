class_name DebugMenu extends Control

@onready var unlock_all_rounds_button: Button = $Panel/UnlockAllRoundsButton
@onready var unlock_bolt_o_matic_button: Button = $Panel/UnlockBoltOMaticButton
@onready var unlock_super_damage_button: Button = $Panel/UnlockSuperDamageButton

@onready var increase_ore_button: Button = $Panel/IncreaseOreButton
@onready var increase_ap_button: Button = $Panel/IncreaseAPButton

@onready var increase_ore_title: Label = $Panel/IncreaseOreTitle
@onready var increase_ap_title: Label = $Panel/IncreaseAPTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_menu() -> void:
	if GameManager.furtherest_round_unlocked == 3:
		unlock_all_rounds_button.text = "Unlocked"
		unlock_all_rounds_button.disabled = true
	
	if GameManager.rifle_owned:
		unlock_bolt_o_matic_button.text = "Unlocked"
		unlock_bolt_o_matic_button.disabled = true
	
	if PlayerStats.player_stats["Attack Damage"] >= 50:
		unlock_super_damage_button.text = "Unlocked"
		unlock_super_damage_button.disabled = true
	
	increase_ore_title.text = "Increase Ore: %s" % int(PlayerStats.player_stats["Ore"])
	increase_ap_title.text = "Increase AP: %s" % int(PlayerStats.player_stats["Ability Points"])


func _on_unlock_all_rounds_button_button_up() -> void:
	GameManager.furtherest_round_unlocked = 3
	init_menu()


func _on_unlock_bolt_o_matic_button_button_up() -> void:
	GameManager.rifle_owned = true
	init_menu()


func _on_unlock_super_damage_button_button_up() -> void:
	PlayerStats.player_stats["Attack Damage"] += 50
	init_menu()


func _on_increase_ore_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] += 20
	init_menu()


func _on_increase_ap_button_button_up() -> void:
	PlayerStats.player_stats["Ability Points"] += 10
	init_menu()
