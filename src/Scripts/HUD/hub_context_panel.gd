class_name HubContextPanel extends Control

var text : Array[String] = [
	"You were once a researcher for the mages army. Your job was to discover new magic tech capable of turning the tides of the demon war. Your test subject was a captive by the name of Beelzebub, one of the highest ranking officers of the Demon Army. Little did you know, applying magic to the general only made him more powerful. Powerful enough to break his shackles and reign terror once more on humanity. He destroys your research facility and makes his escape.",
	"You emerge from the rubble, frustrated with your self and the military's  shortsightedness.  You vow to hunt down Beelzebub and repay humanity for the suffering you've unleashed onto the world. As you begin your trek, you stumble upon a nest of dangerous mutated rats. Before you succumb to their blows, you are rescued by a mysterious merchant man. He decides to assist you on one condition. That you aid him in his black market weapon businessonce these rats are put down for good.",
	"Hub:

This is the main hub. Use this area to prepare for the arena battle. Click on a facility object to access its menu:

- Click the merchant's cart to access the weapon upgrade station
- Click the fireplace to access the stats upgrade menu
- WASD to rotate camera to a different direction
- Hold 'R' to start Arena Combat!

Good luck!"
]
@onready var button: Button = $Panel/Button

@onready var text_label: Label = $Panel/Text
var pos : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	text_label.text = text[pos]
	GameManager.in_menu = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	pos += 1
	
	if pos == text.size():
		GameManager.hub_instructions_shown = true
		GameManager.in_menu = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		SignalBus.hub_context_menu_closed.emit()
		queue_free()
	else:
		text_label.text = text[pos]
		if pos+1 == text.size():
			button.text = "Close"
	

	
