class_name SuperBoltExplosion extends Node3D

var impacted_enemy : Enemy
@onready var explosion: Sprite3D = $Explosion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expand_explosion()

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

func expand_explosion() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(explosion, "scale", Vector3(1.0,1.0,1.0),0.3).set_ease(Tween.EASE_IN_OUT)
