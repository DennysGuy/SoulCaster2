class_name TestRealmDemo extends Node3D

@onready var cut_scene_player: AnimationPlayer = $CutScenePlayer

@onready var animations : Array[String] = ["CameraPan1","CameraPan2","CameraPan3","CameraPan4","CameraPan5"]
var cur_index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cut_scene_player.play("CameraPan1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_random_angle() -> void:
	if cur_index >= animations.size()-1:
		cur_index = 0
	else:
		cur_index += 1
	cut_scene_player.play(animations[cur_index])
