extends Node


signal shake_camera(shake_time : float)

signal xp_was_gained(xp_amount : float)

signal time_added(amount : int)

signal player_hurt(damage : int)

signal time_decremented(value : int)

signal player_damaged

signal ore_gathered

signal alarms_silenced

signal enemy_spawned(enemy : Enemy)

signal enemy_found(enemy_name : String, enemy_hp : int, enemy_max_hp : int)

signal bullet_fired
