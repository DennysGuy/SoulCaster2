class_name BloodSplat extends MeshInstance3D

const BLOOD_MAT_1 = preload("uid://ccj4gn5jcst57")
const BLOOD_MAT_2 = preload("uid://c8vddxqckv3dj")
const BLOOD_MAT_3 = preload("uid://c8q2s2ne1d186")
const BLOOD_MAT_4 = preload("uid://dss4j8w5phkou")

@onready var blood_materials : Array[Material] = [BLOOD_MAT_1, BLOOD_MAT_2, BLOOD_MAT_3, BLOOD_MAT_4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material_override = blood_materials.pick_random()
	rotation.y = randf_range(0.0, 360.0)
	scale = Vector3.ZERO
	spread()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()


func spread() -> void:
	var tween := create_tween()
	var target_scale := randf_range(0.8, 1.5)

	tween.tween_property(
		self,
		"scale",
		Vector3.ONE * target_scale,
		0.2
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
