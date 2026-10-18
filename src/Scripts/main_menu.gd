extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(0,GameManager.master_volume)
	AudioServer.set_bus_volume_db(1,GameManager.sfx_volume)
	AudioServer.set_bus_volume_db(2,GameManager.music_volume)
	AudioServer.set_bus_volume_db(3,GameManager.ambience_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("uid://jgsciuanachx")


func _on_check_box_toggled(toggled_on: bool) -> void:
	GameManager.cut_scenes_disabled = toggled_on
	print(GameManager.cut_scenes_disabled)
