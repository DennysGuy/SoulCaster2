class_name MenuSelectable extends Node3D

@export var menu : PackedScene
@export var look_at_point : Marker3D
@export var canvas_layer : CanvasLayer
@export var move_speed : float = 1.0

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
