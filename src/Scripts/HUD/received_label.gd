class_name ReceivedLabel extends Control

@onready var timer: Timer = $Timer
@export var label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.y -= 1


func _on_timer_timeout() -> void:
	queue_free()
