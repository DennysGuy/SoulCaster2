class_name PauseMenu extends Control

@onready var master_slider: HSlider = $Panel/MasterSlider
@onready var music_slider: HSlider = $Panel/MusicSlider
@onready var sfx_slider: HSlider = $Panel/SFXSlider
@onready var ambience_slider: HSlider = $Panel/AmbienceSlider
@onready var check_button: CheckButton = $CheckButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	master_slider.value = AudioServer.get_bus_volume_db(0)
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	music_slider.value = AudioServer.get_bus_volume_db(2)
	ambience_slider.value = AudioServer.get_bus_volume_db(3)
	check_button.button_pressed = GameManager.target_crosshair_visible

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("close_menu"):
		#GameManager.in_menu = false
		#queue_free()


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,value)

func _on_ambience_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3,value)


func _on_button_button_up() -> void:
	GameManager.in_menu = false
	queue_free()


func _on_check_button_pressed() -> void:
	GameManager.target_crosshair_visible = !GameManager.target_crosshair_visible
