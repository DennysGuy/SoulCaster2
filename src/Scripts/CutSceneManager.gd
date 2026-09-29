extends Node




func show_hub_hud() -> void:
	SignalBus.hub_context_menu_closed.emit()
