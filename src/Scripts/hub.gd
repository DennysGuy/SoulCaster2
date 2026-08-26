class_name Hub extends Node3D

@onready var player: Player = $Player
var start_round_timer : float = 15
var start_round_timer_wait_time : float = 15
@onready var camera: Camera3D = $Player/Head/Camera

var stored_selectable : MenuSelectable
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.in_arena = false
	player.gun_arm.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("start_round"):
		start_round_timer -= 20*delta
		print(start_round_timer)
		if start_round_timer <= 0:
			GameManager.in_arena = true
			get_tree().change_scene_to_file("uid://c8ok5h5m1ggwb")
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
