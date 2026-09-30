extends Node




func show_hub_hud() -> void:
	SignalBus.hub_context_menu_closed.emit()


func start_intro_cutscene() -> void:
	SignalBus.intro_cutscene_started.emit()

func return_player_to_home_during_cutscene() -> void:
	SignalBus.intro_cutscene_player_return.emit()

func move_player_to_campfire_during_cutscene() -> void:
	SignalBus.intro_cutscene_move_player_to_campfire.emit()

func move_player_to_cart_during_cutscene() -> void:
	SignalBus.intro_cutscene_return_player_to_cart.emit()

func show_controls_label() -> void:
	SignalBus.control_label_revealed.emit()

func show_start_battle_label() -> void:
	SignalBus.start_battle_label_revealed.emit()

func start_combat_round() -> void:
	SignalBus.hunt_round_ended.emit()

func start_hunt_countdown() -> void:
	SignalBus.hunt_tutorial_ended.emit()

func end_cutscene() -> void:
	SignalBus.cutscene_ended.emit()

func start_boss_fight() -> void:
	SignalBus.boss_cutscene_ended.emit()
