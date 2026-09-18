class_name ShopMenu extends Control

@onready var purchase_radar_button: Button = $Panel/PurchaseRadarButton
@onready var purchase_rifle_button: Button = $WeaponPanel/PurchaseRifleButton

@onready var purchase_tracker_button: Button = $Panel/PurchaseTrackerButton

@onready var tip_1: Label = $WeaponPanel/Tip1
@onready var ore_count: Label = $WeaponPanel/OreCount
@onready var bolt_o_matic_title: Label = $WeaponPanel/BoltOMaticTitle


@onready var pistol_mag_size: Label = $Panel/PistolMagSize
@onready var rifle_mag_size: Label = $Panel/RifleMagSize

@onready var purchase_pistol_mag_button: Button = $Panel/PurchasePistolMagButton
@onready var purchase_rifle_mag_button: Button = $Panel/PurchaseRifleMagButton

@onready var pistol_magazine_cost: Label = $Panel/PistolMagazineCost
@onready var rifle_magazine_cost: Label = $Panel/RifleMagazineCost

@onready var fortified_pistol_bullets_button: Button = $Panel/FortifiedPistolBulletsButton
@onready var fortified_rfiel_bullets_button: Button = $Panel/FortifiedRfielBulletsButton

@onready var cross_bow_ammo_purchase_button: Button = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/QuiverSize/CrossBowAmmoPurchaseButton
@onready var mining_cross_bow_bolt_purchase_button: Button = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/CrossBowMiningBolt/MiningCrossBowBoltPurchaseButton
@onready var bolt_o_matic_mag_size_purchase_button: Button = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/BoltOMaticMagazineSize/BoltOMaticMagSizePurchaseButton
@onready var bolt_o_matic_minin_bolt_purchase_button: Button = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/BoltOMaticMagazineSize2/BoltOMaticMininBoltPurchaseButton

@onready var cross_bow_quiver_size: Label = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/QuiverSize/CrossBowQuiverSize
@onready var cross_bow_quiver_cost: Label = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/QuiverSize/CrossBowQuiverCost

@onready var bolt_o_matic_mag_size: Label = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/BoltOMaticMagazineSize/BoltOMaticMagSize
@onready var bolt_o_matic_mag_size_cost: Label = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel/BoltOMaticMagazineSize/BoltOMaticMagSizeCost

@onready var radar_purchase_button: Button = $UpgradesPanel/MarginContainer/AmuletsPanel/RadarAmulet/RadarPurchaseButton
@onready var tracker_puchase_button: Button = $UpgradesPanel/MarginContainer/AmuletsPanel/TrackerAmulet/TrackerPuchaseButton

@onready var amulets_panel: Panel = $UpgradesPanel/MarginContainer/AmuletsPanel
@onready var weapon_upgrades_panel: Panel = $UpgradesPanel/MarginContainer/WeaponUpgradesPanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var grenade_title: Label = $UpgradesPanel/MarginContainer/SpecialWeapons/RadarAmulet/GrenadeTitle
@onready var grenade_purchase_button: Button = $UpgradesPanel/MarginContainer/SpecialWeapons/RadarAmulet/GrenadePurchaseButton
@onready var special_weapons: Panel = $UpgradesPanel/MarginContainer/SpecialWeapons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("SpawnIn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_menu()
	update_weapon_upgrades_panel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_purchase_rifle_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 100
	GameManager.rifle_owned = true
	update_menu()
	update_amulet_menu()
	update_weapon_upgrades_panel()
	
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
	
func _on_purchase_radar_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 30
	GameManager.amulet_owned = true
	update_menu()

func _on_close_menu_button_up() -> void:
	GameManager.in_menu = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SignalBus.shop_exited.emit()
	SignalBus.menu_exited.emit()
	animation_player.play("SpawnOut")
	await animation_player.animation_finished
	queue_free()

func _on_purchase_tracker_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 20
	GameManager.enemy_tracker_owned = true
	update_menu()

func _on_purchase_pistol_mag_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.pistol_mag_cost
	GameManager.pistol_magazine_size += 1
	GameManager.pistol_mag_cost *= 2
	update_menu()

func _on_purchase_rifle_mag_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.rifle_mag_cost
	GameManager.rifle_magazine_size += 2
	GameManager.rifle_mag_cost *= 2
	update_menu()

func _on_fortified_pistol_bullets_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_bullets_cost
	GameManager.fortified_pistol_bullets = true
	update_weapon_upgrades_panel()
	update_menu()

func _on_fortified_rfiel_bullets_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_rifle_cost
	GameManager.fortified_rifle_bullets = true
	update_weapon_upgrades_panel()
	update_menu()

func _on_cross_bow_ammo_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.pistol_mag_cost
	GameManager.pistol_magazine_size += 1
	GameManager.pistol_mag_cost *= 2
	update_weapon_upgrades_panel()
	update_menu()

func _on_mining_cross_bow_bolt_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_bullets_cost
	GameManager.fortified_pistol_bullets = true
	update_weapon_upgrades_panel()
	update_menu()

func _on_bolt_o_matic_mag_size_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.rifle_mag_cost
	GameManager.rifle_magazine_size += 2
	GameManager.rifle_mag_cost *= 2
	update_weapon_upgrades_panel()
	update_menu()

func _on_bolt_o_matic_minin_bolt_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.fortified_pistol_rifle_cost
	GameManager.fortified_rifle_bullets = true
	update_weapon_upgrades_panel()
	update_menu()

func update_weapon_upgrades_panel() -> void:
	
	if PlayerStats.player_stats["Ore"] < GameManager.pistol_mag_cost:
		cross_bow_ammo_purchase_button.disabled = true
		cross_bow_ammo_purchase_button.text = "Insufficient Ore"
	else:
		cross_bow_ammo_purchase_button.disabled = false
		cross_bow_ammo_purchase_button.text = "Purchase!"
		
	if PlayerStats.player_stats["Ore"] < GameManager.rifle_mag_cost:
		bolt_o_matic_mag_size_purchase_button.disabled = true
		bolt_o_matic_mag_size_purchase_button.text = "Insufficient Ore"
	else:
		bolt_o_matic_mag_size_purchase_button.disabled = false
		bolt_o_matic_mag_size_purchase_button.text = "Purchase!"	

	if !GameManager.fortified_pistol_bullets:
		if PlayerStats.player_stats["Ore"] >= GameManager.fortified_pistol_bullets_cost:
			mining_cross_bow_bolt_purchase_button.disabled = false
			mining_cross_bow_bolt_purchase_button.text = "Purchase!"
		else:
			mining_cross_bow_bolt_purchase_button.disabled = true
			mining_cross_bow_bolt_purchase_button.text = "Insufficient Ore"
	else:
		mining_cross_bow_bolt_purchase_button.disabled = true
		mining_cross_bow_bolt_purchase_button.text = "Owned"
	
	
	if !GameManager.fortified_rifle_bullets:
		if PlayerStats.player_stats["Ore"] >= GameManager.fortified_pistol_rifle_cost:
			bolt_o_matic_minin_bolt_purchase_button.disabled = false
			bolt_o_matic_minin_bolt_purchase_button.text = "Purchase!"
		else:
			bolt_o_matic_minin_bolt_purchase_button.disabled = true
			bolt_o_matic_minin_bolt_purchase_button.text = "Insufficient Ore"
	else:
		bolt_o_matic_minin_bolt_purchase_button.disabled = true
		bolt_o_matic_minin_bolt_purchase_button.text = "Owned"

	cross_bow_quiver_size.text = "Cross Bow Quiver Size: %s" % GameManager.pistol_magazine_size
	bolt_o_matic_mag_size.text = "Bolt-O-Matic Mag Size: %s" % GameManager.rifle_magazine_size

	cross_bow_quiver_cost.text = "x %s" % GameManager.pistol_mag_cost
	bolt_o_matic_mag_size_cost.text = "x %s" % GameManager.rifle_mag_cost



func update_amulet_menu() -> void:
	if !GameManager.amulet_owned:
		if PlayerStats.player_stats["Ore"] >= 30:
			radar_purchase_button.disabled = false
			radar_purchase_button.text = "Purchase!"
		else:
			radar_purchase_button.disabled = true
			radar_purchase_button.text = "Insufficient Ore"
	else:
		radar_purchase_button.disabled = true
		radar_purchase_button.text = "Owned"

	if !GameManager.enemy_tracker_owned:
		if PlayerStats.player_stats["Ore"] >= 20:
			tracker_puchase_button.disabled = false
			tracker_puchase_button.text = "Purchase!"
		else:
			tracker_puchase_button.disabled = true
			tracker_puchase_button.text = "Insufficient Ore"
	else:
		tracker_puchase_button.disabled = true
		tracker_puchase_button.text = "Owned"

func _on_radar_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 30
	GameManager.amulet_owned = true
	update_amulet_menu()
	update_menu()

func _on_tracker_puchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= 20
	GameManager.enemy_tracker_owned = true
	update_amulet_menu()
	update_menu()

func _on_weapon_upgrades_button_button_up() -> void:
	update_weapon_upgrades_panel()
	update_menu()
	weapon_upgrades_panel.show()
	amulets_panel.hide()
	special_weapons.hide()

func _on_amulets_button_button_up() -> void:
	update_amulet_menu()
	update_menu()
	amulets_panel.show()
	weapon_upgrades_panel.hide()
	special_weapons.hide()

func _on_grenade_purchase_button_button_up() -> void:
	PlayerStats.player_stats["Ore"] -= GameManager.basic_grenade_cost
	GameManager.grenades_owned += 1
	update_special_weapons_menu()
	update_menu()
	
func update_special_weapons_menu() -> void:
	grenade_title.text = "Grenade (%s Owned)" % GameManager.grenades_owned
	if PlayerStats.player_stats["Ore"] >= GameManager.basic_grenade_cost:
		grenade_purchase_button.disabled = false
		grenade_purchase_button.text = "Purchase!"
	else:
		grenade_purchase_button.disabled = true
		grenade_purchase_button.text = "Insufficient Ore"

func _on_special_weapons_button_button_up() -> void:
	weapon_upgrades_panel.hide()
	amulets_panel.hide()
	update_special_weapons_menu()
	special_weapons.show()
