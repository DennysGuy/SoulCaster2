class_name Hub extends Node3D

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.in_arena = false
	player.gun_arm.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
