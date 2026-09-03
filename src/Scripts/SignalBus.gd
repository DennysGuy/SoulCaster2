extends Node


signal shake_camera(shake_time : float)

signal xp_was_gained(xp_amount : float)

signal time_added(amount : int)

signal player_hurt(damage : int)

signal time_decremented(value : int)

signal player_damaged

signal ore_gathered(amount : int)

signal alarms_silenced

signal enemy_spawned(enemy : Enemy)

signal enemy_found(enemy_name : String, enemy_hp : int, enemy_max_hp : int)

signal bullet_fired

signal round_ended

signal round_started

signal time_received(message : int)
signal xp_received(message : int)

signal progress_added(value : float)

signal boss_fight_started
signal face_boss_area
signal combat_engaged
signal boss_damaged(health: int,max_health : int)
signal boss_defeated
signal arena_context_button_closed
signal hub_context_menu_closed
