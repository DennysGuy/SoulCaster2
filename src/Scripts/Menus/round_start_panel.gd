class_name StartRoundPanel extends Panel

@onready var round_selected_label: Label = $Panel/RoundSelectedLabel

@onready var decrease_round: TextureButton = $DecreaseRound
@onready var increase_round: TextureButton = $IncreaseRound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.current_round_selected = GameManager.furtherest_round_unlocked
	update_round_label()
	
	if GameManager.current_round_selected == 0:
		increase_round.disabled = true
		decrease_round.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file("uid://c8ok5h5m1ggwb")

func _on_close_button_button_up() -> void:
	GameManager.in_menu = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()

func update_round_label() -> void:
	round_selected_label.text = "Round %s" % (GameManager.current_round_selected+1)
	
func _on_decrease_round_button_up() -> void:
	GameManager.current_round_selected -= 1
	if GameManager.current_round_selected < 0:
		GameManager.current_round_selected = GameManager.furtherest_round_unlocked
	update_round_label()

func _on_increase_round_button_up() -> void:
	GameManager.current_round_selected += 1
	if GameManager.current_round_selected > GameManager.furtherest_round_unlocked:
		GameManager.current_round_selected = 0
	update_round_label()
