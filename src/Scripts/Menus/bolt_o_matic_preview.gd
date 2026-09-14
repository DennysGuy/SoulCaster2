class_name BoltOMaticPreview extends Node3D

@onready var ultra_bow_anchor: Node3D = $UltraBowAnchor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	ultra_bow_anchor.rotation.y -= 0.01
