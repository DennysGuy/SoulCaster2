class_name HubContextPanel extends Control

@onready var button: Button = $Panel/Button

@onready var text_label: Label = $Panel/Text
var pos : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.in_menu = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_button_up() -> void:
	GameManager.in_menu = false
	queue_free()
	

	
