class_name SuperBoltExplosion extends Node3D

var impacted_enemy : Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_instance_valid(impacted_enemy) and body == impacted_enemy:
		return
	
	if is_instance_valid(body) and body is Enemy or is_instance_valid(body) and body is BabyBullet :
		var damage : int = randi_range(PlayerStats.player_stats["Grenade Damage"]-2, PlayerStats.player_stats["Grenade Damage"]+2)
		if is_instance_valid(body):
			body.damage_enemy(damage)

func _on_timer_timeout() -> void:
	queue_free()
