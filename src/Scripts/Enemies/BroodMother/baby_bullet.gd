class_name BabyBullet extends CharacterBody3D

@onready var bulletrat_2: Node3D = $bulletrat2

@onready var animation_player: AnimationPlayer = $bulletrat2/AnimationPlayer
var attack_damage: int = 3
var move_speed : float = 200
var player : Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	bulletrat_2.rotation.z += 0.1

	if player:
		var direction : Vector3 = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * move_speed * delta
		look_at(player.global_transform.origin, Vector3.UP)
		move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		attack_player()

func attack_player() -> void:
	SignalBus.player_hurt.emit(attack_damage)
	SignalBus.shake_camera.emit(1.0)
	SignalBus.player_damaged.emit()
	queue_free()
