class_name BloodSpirt extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	amount = randi_range(4,12)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	print("I'm out!")
	queue_free()
