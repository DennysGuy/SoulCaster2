class_name DamageLabel extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var label: Label
@export var texture_rect: TextureRect
const DAMAGE_LABEL_BG_CRIT = preload("uid://csrmruswdmytm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_num : int = randi_range(0,100)
	if rand_num <= 50:
		animation_player.play("FlyLeft")
	else:
		animation_player.play("FlyRight")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_bg_as_crit() -> void:
	texture_rect.texture = DAMAGE_LABEL_BG_CRIT
