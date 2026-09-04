class_name CrossHair extends TextureRect

var offset
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.shot_fired.connect(pulse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	position = mouse_position - (get_rect().size/2)

func pulse() -> void:
	var tween : Tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(0.6,0.6),0.1).finished
	var tween_2 : Tween = create_tween()
	await tween_2.tween_property(self, "scale", Vector2(1.3,1.3),0.1).finished
	var tween_3 : Tween = create_tween()
	tween_3.tween_property(self, "scale", Vector2(1.0,1.0),0.1)
