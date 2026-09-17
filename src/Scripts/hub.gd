class_name Hub extends Node3D

@onready var player: Player = $Player
var start_round_timer : float = 15
var start_round_timer_wait_time : float = 15
@onready var camera: Camera3D = $Player/Head/Camera

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var level: Label = $CanvasLayer/ProgressBar/Level
@onready var ap: Label = $CanvasLayer/ProgressBar/AP
@onready var xp: Label = $CanvasLayer/ProgressBar/XP

@onready var hud_animation_player: AnimationPlayer = $HUDAnimationPlayer
const START_FIGHT = preload("uid://pf7s6r3v0oal")
@onready var music: AudioStreamPlayer = $Music

var stored_selectable : MenuSelectable
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var start_battle_label: Label = $CanvasLayer/StartBattleLabel
@onready var controls_label: Label = $CanvasLayer/ControlsLabel

@onready var home_position: Marker3D = $HomePosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud_animation_player.play("CloseIn")
	SignalBus.hub_context_menu_closed.connect(show_start_combat_label)
	SignalBus.menu_exited.connect(move_player_to_home)
	SignalBus.arena_started.connect(play_close_out)
	GameManager.in_arena = false
	GameManager.in_menu = false
	player.gun_arm.hide()
	if !GameManager.hub_instructions_shown:
		progress_bar.hide()
		start_battle_label.hide()
		controls_label.hide()
		spawn_hub_context()
	
	progress_bar.max_value = PlayerStats.player_stats["Needed XP"]
	progress_bar.value = PlayerStats.player_stats["Current XP"]
	xp.text = "[%s/%s]" % [int(PlayerStats.player_stats["Current XP"]),int(PlayerStats.player_stats["Needed XP"])]
	ap.text = "AP: %s" % int(PlayerStats.player_stats["Ability Points"])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("start_round"):
		spawn_round_select_menu()
	else:
		start_round_timer = start_round_timer_wait_time

	if !GameManager.in_arena:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 15000

		var space_state = get_world_3d().direct_space_state
		
		# Create ray query and set collision mask to layer 6
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask = 1 << 5  # layer 6 (layers are 0-indexed)
		
		var result = space_state.intersect_ray(query)

	
		if result and result["collider"].get_parent() is MenuSelectable:
			if !stored_selectable:
				print(result["collider"].get_parent())
				stored_selectable = result["collider"].get_parent()
		else:
			if stored_selectable:
				stored_selectable = null

		#SignalBus.reset_combo_meter.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if stored_selectable and !GameManager.in_menu:
				stored_selectable.open_menu()
				if stored_selectable.has_method("play_activation_animation"):
					stored_selectable.play_activation_animation()
				move_player_to_shop(stored_selectable.look_at_point,stored_selectable.move_speed)

func spawn_hub_context() -> void:
	var hub_context_panel : HubContextPanel = preload("uid://cnv6x8tgahuc1").instantiate()
	canvas_layer.add_child(hub_context_panel)

func show_start_combat_label() -> void:
	start_battle_label.show()
	controls_label.show()
	progress_bar.show()

func spawn_round_select_menu() -> void:
	GameManager.in_menu = true
	var round_select_menu : StartRoundPanel =preload("uid://noxi046h5l3k").instantiate()
	canvas_layer.add_child(round_select_menu)

func move_player_to_shop(marker : Marker3D, move_speed : float) -> void:
	GameManager.can_move = false
	var tween : Tween = create_tween()
	tween.tween_property(player, "global_position",marker.global_position,move_speed)
	await tween.finished

func move_player_to_home() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(player, "global_position",home_position.global_position,0.5)
	await tween.finished
	GameManager.can_move = true

func play_close_out() -> void:
	music.stop()
	GameManager.play_sfx(START_FIGHT)
	hud_animation_player.play("CloseOut")
