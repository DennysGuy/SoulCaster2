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
	SignalBus.combat_tutorial_ended.emit()

func start_hunt_countdown() -> void:
	SignalBus.hunt_tutorial_ended.emit()

func end_cutscene() -> void:
	SignalBus.cutscene_ended.emit()

func start_boss_fight() -> void:
	SignalBus.boss_cutscene_ended.emit()

func start_cutscene() -> void:
	SignalBus.cutscene_started.emit()

func add_shop_guy_portrait() -> void:
	SignalBus.shop_guy_entered.emit()

func remove_shop_guy_portrait() -> void:
	SignalBus.shop_guy_exited.emit()

func add_boss_portrait() -> void:
	SignalBus.boss_entered.emit()

func stop_music() -> void:
	SignalBus.stop_music.emit()

func play_fade_out() -> void:
	SignalBus.game_ended.emit()

func play_merchant_talk_1() -> void:
	SignalBus.merchant_talked.emit()

func play_merchant_talk_2() -> void:
	SignalBus.merchant_talked_2.emit()

func play_merchant_talk_3() -> void:
	SignalBus.merchant_talked_dissapointed.emit()

func play_merchant_idle_1() -> void:
	SignalBus.merchant_idled_1.emit()

func play_merchant_idle_2() -> void:
	SignalBus.merchant_idled_2.emit()

func play_merchant_idle_in_cart_1() -> void:
	SignalBus.merchant_idle_in_cart_1.emit()

func play_merchant_idle_in_cart_2() -> void:
	SignalBus.merchant_idle_in_cart_2.emit()

func start_merchant_idle() -> void:
	SignalBus.intro_ended.emit()
