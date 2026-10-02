class_name MenuSelectable extends Node3D

@export var shop_name : String
@export var menu : PackedScene
@export var look_at_point : Marker3D
@export var canvas_layer : CanvasLayer
@export var move_speed : float = 1.0
@export var outline_mesh : MeshInstance3D
const OUTLINE_MATERIAL = preload("uid://dm4j4o3t0e0k7")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_menu() -> void:
	var chosen_menu = menu.instantiate()
	canvas_layer.add_child(chosen_menu)
	GameManager.in_menu = true


func set_outline() -> void:
	var mat : Material = outline_mesh.get_active_material(0)
	mat.next_pass = OUTLINE_MATERIAL
	SignalBus.shop_hovered_over.emit(shop_name)

func remove_outline() -> void:
	var mat : Material = outline_mesh.get_active_material(0)
	mat.next_pass = null
	SignalBus.shop_hover_exited.emit()
