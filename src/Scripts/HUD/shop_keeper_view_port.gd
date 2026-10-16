class_name ShopKeeperViewPort extends Control

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_shop_guy()
	SignalBus.shop_guy_exited.connect(hide_shop_guy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_shop_guy() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(sub_viewport_container, "position", Vector2(0,0), 0.3).set_ease(Tween.EASE_IN_OUT)

func hide_shop_guy() -> void:
	var tween : Tween = create_tween()
	await tween.tween_property(sub_viewport_container, "position", Vector2(0,1080), 0.3).set_ease(Tween.EASE_IN_OUT).finished
	queue_free()
