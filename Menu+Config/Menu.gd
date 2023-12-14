extends Control

@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var top_score_label = $"MarginContainer/VBoxContainer/TopScoreLabel"
var config_manager = Config_Manager.new()

func _ready():
	var loaded_last_score = config_manager.load_last_score()
	var loaded_top_score = config_manager.load_top_score()
	
	score_label.text = "Last   round    score   is:   " + str(loaded_last_score)
	top_score_label.text = "Best   score   is:   " + str(loaded_top_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")
