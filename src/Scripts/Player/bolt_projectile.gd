class_name BoltProjectile extends Node3D

@export var speed : float = 100
var direction : Vector3 = Vector3.ZERO
var target : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if direction == Vector3.ZERO:
		direction = Vector3(0,0,1)
	
	look_at(global_position + direction, Vector3.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		var target_position : Vector3 = target.bolt_position.global_position
		var offset : Vector3 = global_position.direction_to(target_position)
		
		if global_position.distance_squared_to(target_position) > 0.01:
			direction = offset

	if direction.length_squared() > 0.001:
		look_at(global_position + direction, Vector3.UP)

	global_position += direction * speed * delta
	
	if target and global_position.distance_to(target.bolt_position.global_position) <= 1.0:
		if target is BabyBullet:
			target.die()
			queue_free()
		elif target is Enemy:
			if target.can_hurt:
				target.damage_enemy()
			queue_free()
		elif target is TestOre:
			target.damage_ore()
			queue_free()

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	var body_parent := body.get_parent()
	if body_parent == target:
		if body is EnemyBodyCollider:
			if body_parent is BabyBullet:
				body_parent.die()
				queue_free()
			body_parent.damage_enemy()
			queue_free()
		elif body is OreCollider:
			body_parent.damage_ore()
			queue_free()


func _on_timer_timeout() -> void:
	queue_free()
