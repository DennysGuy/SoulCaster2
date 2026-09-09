class_name EnemyConfiguration extends Node3D

@export var enemies : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemies.get_children().is_empty():
		queue_free()
