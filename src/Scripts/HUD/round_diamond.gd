class_name RoundDiamond extends TextureRect

@export var wave_graphic_unfilled : Texture2D
@export var wave_graphic_filled : Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = wave_graphic_unfilled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_diamond() -> void:
	texture = wave_graphic_filled
