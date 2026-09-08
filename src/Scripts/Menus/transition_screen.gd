class_name TransitionScreen extends Control

@onready var shots_fired_label: Label = $ShotsFiredLabel
@onready var accuracy: Label = $Accuracy
@onready var enemies_killed_label: Label = $EnemiesKilledLabel
@onready var levels_gained_label: Label = $LevelsGainedLabel
@onready var xp_gained_label: Label = $XPGainedLabel
@onready var ore_acquired_label: Label = $OreAcquiredLabel
@onready var rounds_completed_label: Label = $RoundsCompletedLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	shots_fired_label.text = "Total Shots Fired: %s" % GameManager.shots_fired
	#var the_accuracy : int = (GameManager.hits/GameManager.shots_fired) * 100
	#print("THIS IS HITS %s " % GameManager.hits)
	#accuracy.text = "Accuracy: %s" % the_accuracy
	enemies_killed_label.text = "Enemies Slain: %s" % GameManager.enemies_killed
	levels_gained_label.text = "Levels Gained: %s/%s" % [GameManager.levels_gained,int(PlayerStats.player_stats["Level"])]
	xp_gained_label.text = "XP Gained: %s" % GameManager.xp_gained
	ore_acquired_label.text = "Ore Acquired: %s/%s" %[GameManager.ore_acquired, int(PlayerStats.player_stats["Ore"])]
	rounds_completed_label.text = "Rounds Completed: %s" % GameManager.rounds_beaten
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_to_hub_button_button_up() -> void:
	get_tree().change_scene_to_file("uid://jgsciuanachx")


func _on_try_again_button_button_up() -> void:
	get_tree().change_scene_to_file("uid://c8ok5h5m1ggwb")
