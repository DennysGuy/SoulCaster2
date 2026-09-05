class_name ShopMenu extends Control

@onready var purchase_radar_button: Button = $Panel/PurchaseRadarButton
@onready var purchase_rifle_button: Button = $Panel/PurchaseRifleButton
@onready var purchase_tracker_button: Button = $Panel/PurchaseTrackerButton
@onready var ore_count: Label = $Panel/OreCount

@onready var pistol_mag_size: Label = $Panel/PistolMagSize
@onready var rifle_mag_size: Label = $Panel/RifleMagSize

@onready var purchase_pistol_mag_button: Button = $Panel/PurchasePistolMagButton
@onready var purchase_rifle_mag_button: Button = $Panel/PurchaseRifleMagButton

@onready var pistol_magazine_cost: Label = $Panel/PistolMagazineCost
@onready var rifle_magazine_cost: Label = $Panel/RifleMagazineCost

@onready var fortified_pistol_bullets_button: Button = $Panel/FortifiedPistolBulletsButton
@onready var fortified_rfiel_bullets_button: Button = $Panel/FortifiedRfielBulletsButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_purchase_rifle_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 100
	GameManager.rifle_owned = true
	update_menu()

func update_menu() -> void:
	ore_count.text = "x %s" % int(PlayerStats.player_stats["Ore"])
	if !GameManager.rifle_owned:
		if PlayerStats.player_stats["Ore"] >= 100:
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
		if PlayerStats.player_stats["Ore"] >= 20:
			purchase_tracker_button.disabled = false
			purchase_tracker_button.text = "Purchase!"
		else:
			purchase_tracker_button.disabled = true
			purchase_tracker_button.text = "Insufficient Ore"
	else:
		purchase_tracker_button.disabled = true
		purchase_tracker_button.text = "Owned"

	if PlayerStats.player_stats["Ore"] < GameManager.pistol_mag_cost:
		purchase_pistol_mag_button.disabled = true
		purchase_pistol_mag_button.text = "Insufficient Ore"
	else:
		purchase_pistol_mag_button.disabled = false
		purchase_pistol_mag_button.text = "Purchase!"
		
		
	if PlayerStats.player_stats["Ore"] < GameManager.rifle_mag_cost:
		purchase_rifle_mag_button.disabled = true
		purchase_rifle_mag_button.text = "Insufficient Ore"
	else:
		purchase_rifle_mag_button.disabled = false
		purchase_rifle_mag_button.text = "Purchase!"	

	if !GameManager.fortified_pistol_bullets:
		if PlayerStats.player_stats["Ore"] >= GameManager.fortified_pistol_bullets_cost:
			fortified_pistol_bullets_button.disabled = false
			fortified_pistol_bullets_button.text = "Purchase!"
		else:
			fortified_pistol_bullets_button.disabled = true
			fortified_pistol_bullets_button.text = "Insufficient Ore"
	else:
		fortified_pistol_bullets_button.disabled = true
		fortified_pistol_bullets_button.text = "Owned"

	if !GameManager.fortified_rifle_bullets:
		if PlayerStats.player_stats["Ore"] >= GameManager.fortified_pistol_rifle_cost:
			fortified_rfiel_bullets_button.disabled = false
			fortified_rfiel_bullets_button.text = "Purchase!"
		else:
			fortified_rfiel_bullets_button.disabled = true
			fortified_rfiel_bullets_button.text = "Insufficient Ore"
	else:
		fortified_rfiel_bullets_button.disabled = true
		fortified_rfiel_bullets_button.text = "Owned"

	pistol_magazine_cost.text = "x %s" % GameManager.pistol_mag_cost
	rifle_magazine_cost.text = "x %s" % GameManager.rifle_mag_cost

func _on_purchase_radar_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 20
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


func _on_purchase_pistol_mag_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.pistol_mag_cost
	GameManager.pistol_magazine_size += 2
	GameManager.pistol_mag_cost *= 2
	update_menu()


func _on_purchase_rifle_mag_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.rifle_mag_cost
	GameManager.rifle_magazine_size += 4
	GameManager.rifle_mag_cost *= 2
	update_menu()


func _on_fortified_pistol_bullets_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_bullets_cost
	GameManager.fortified_pistol_bullets = true
	update_menu()


func _on_fortified_rfiel_bullets_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_rifle_cost
	GameManager.fortified_rifle_bullets = true
	update_menu()
