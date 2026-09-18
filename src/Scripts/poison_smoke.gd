class_name PoisonSmoke extends Node3D

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

var damage_timer : float = 20
var damage_wait_time : float = 20
@onready var alive_timer: Timer = $AliveTimer
@onready var area_3d: Area3D = $Area3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_3d.play()
	alive_timer.start()
	await get_tree().process_frame
	damage_enemies_in_range()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	damage_timer -= 12 * delta
	if damage_timer <= 0:
		damage_enemies_in_range()
		damage_timer = damage_wait_time

func _on_alive_timer_timeout() -> void:
	gpu_particles_3d.emitting = false
	await get_tree().create_timer(1.0).timeout
	queue_free()

func damage_enemies_in_range() -> void:
	var enemies = area_3d.get_overlapping_bodies()
	
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy is Enemy:
			var damage : int = randi_range(PlayerStats.player_stats["Grenade Damage"]-2, PlayerStats.player_stats["Grenade Damage"]+2)
			enemy.damage_enemy(damage)
			await get_tree().create_timer(0.3).timeout
