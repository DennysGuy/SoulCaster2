class_name RoundDiamond extends TextureRect

const WAVE_DIAMOND_FILLED = preload("uid://d3apwcm4ylvd2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_diamond() -> void:
	texture = WAVE_DIAMOND_FILLED
