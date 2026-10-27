class_name SuperBoltExplosion extends Node3D

var impacted_enemy : Enemy
@onready var explosion: Sprite3D = $Explosion
@onready var area_3d: Area3D = $Area3D
var explosion_started : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expand_explosion()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !explosion_started:
		var overlapping_bodies = area_3d.get_overlapping_bodies()
		for enemy in overlapping_bodies:
			var parent = enemy.get_parent()
			var damage : int = randi_range(PlayerStats.player_stats["Grenade Damage"]-2, PlayerStats.player_stats["Grenade Damage"]+2)
			if is_instance_valid(parent) and parent is Enemy:
				parent.damage_enemy(damage)
		explosion_started = true

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
	tween.tween_property(explosion, "scale", Vector3(5.0,5.0,5.0),0.2).set_ease(Tween.EASE_IN_OUT)
