class_name MenuSelectable extends Node3D

@export var menu : PackedScene
@export var canvas_layer : CanvasLayer

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
