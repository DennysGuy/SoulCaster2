class_name Cart extends MenuSelectable

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.shop_exited.connect(play_deactivation_animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_activation_animation() -> void:
	animation_player.speed_scale = 2.5
	animation_player.play("climb in")

func play_deactivation_animation() -> void:
	animation_player.speed_scale = 1.0
	animation_player.play_backwards("climb in")
