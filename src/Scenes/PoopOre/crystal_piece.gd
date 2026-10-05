class_name CrystalPiece extends Node3D

var player : Player
var move_to_player : bool = false
@onready var timer: Timer = $Timer

@onready var forward = -global_transform.basis.z
@onready var right = global_transform.basis.x
@onready var angle = randf_range(-PI/2.0,PI/2.0)
@onready var direction = (forward * cos(angle) + right * sin(angle)).normalized() 
@onready var distance = randf_range(1.2,2.2)

@onready var spawn_pos : Vector3 = global_position + direction * distance
@onready var sprite_3d: Sprite3D = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	look_at(player.point_at_marker.global_position, Vector3.UP)
	
	var random_rot : float = randf_range(0,360)
	sprite_3d.rotation.z = random_rot
	move_to_position()
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_to_player:
		var target = player.point_at_marker.global_position - Vector3(0.0,2.0,0.0)
		var speed = 30.0
		global_position = global_position.move_toward(target, speed * delta)

func move_to_position() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "global_position", spawn_pos, 0.5)

func _on_timer_timeout() -> void:
	move_to_player = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		queue_free()
