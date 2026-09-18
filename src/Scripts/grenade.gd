class_name Grenade extends CharacterBody3D


@export var speed : float
const JUMP_VELOCITY = 4.5
@onready var timer: Timer = $Timer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var direction : Vector3 = Vector3.ZERO
const GRENADE_FLY_IN_AIR = preload("uid://76lhgpao5pgi")
const GRENADE_TOSS = preload("uid://br5xvc8wkgq8a")
const GRENADE_EXPLOSION_1 = preload("uid://gme5v7mb5hdq")
const GRENADE_EXPLOSION_2 = preload("uid://r8to2qyj1h28")
const GRENADE_EXPLOSION_3 = preload("uid://unhr17gjk3qj")

@onready var explosions : Array[AudioStream] = [GRENADE_EXPLOSION_1, GRENADE_EXPLOSION_2, GRENADE_EXPLOSION_3]

func _ready() -> void:
	#timer.start()
	#velocity.y -= 50
	play_sfx(GRENADE_FLY_IN_AIR)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		SignalBus.shake_camera.emit(1.5)
		spawn_smoke()
		queue_free()

	move_and_slide()

func _on_timer_timeout() -> void:
	SignalBus.shake_camera.emit(1.5)
	
	queue_free()


func spawn_smoke() -> void:
	GameManager.play_sfx(explosions.pick_random())
	var smoke : PoisonSmoke = preload("uid://dd7wa1ar6qtpn").instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)

func play_sfx(audio_stream : AudioStream) -> void:
	audio_stream_player_3d.stream = audio_stream
	audio_stream_player_3d.play()
