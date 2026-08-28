class_name ShopMenu extends Control

@onready var purchase_radar_button: Button = $Panel/PurchaseRadarButton
@onready var purchase_rifle_button: Button = $Panel/PurchaseRifleButton
@onready var purchase_tracker_button: Button = $Panel/PurchaseTrackerButton
@onready var ore_count: Label = $Panel/OreCount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_purchase_rifle_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 50
	GameManager.rifle_owned = true
	update_menu()

func update_menu() -> void:
	ore_count.text = "x %s" % int(PlayerStats.player_stats["Ore"])
	if !GameManager.rifle_owned:
		if PlayerStats.player_stats["Ore"] >= 50:
			purchase_rifle_button.disabled = false
			purchase_rifle_button.text = "Purchase!"
		else:
			purchase_rifle_button.disabled = true
			purchase_rifle_button.text = "Insufficient Ore"
	else:
		purchase_rifle_button.disabled = true
		purchase_rifle_button.text = "Owned"
	
	if !GameManager.amulet_owned:
		if PlayerStats.player_stats["Ore"] >= 30:
			purchase_radar_button.disabled = false
			purchase_radar_button.text = "Purchase!"
		else:
			purchase_radar_button.disabled = true
			purchase_radar_button.text = "Insufficient Ore"
	else:
		purchase_radar_button.disabled = true
		purchase_radar_button.text = "Owned"

	if !GameManager.enemy_tracker_owned:
		if PlayerStats.player_stats["Ore"] >= 15:
			purchase_tracker_button.disabled = false
			purchase_tracker_button.text = "Purchase!"
		else:
			purchase_tracker_button.disabled = true
			purchase_tracker_button.text = "Insufficient Ore"
	else:
		purchase_tracker_button.disabled = true
		purchase_tracker_button.text = "Owned"

func _on_purchase_radar_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 30
	GameManager.amulet_owned = true
	update_menu()

func _on_close_menu_button_up() -> void:
	GameManager.in_menu = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()

func _on_purchase_tracker_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 15
	GameManager.enemy_tracker_owned = true
	update_menu()
