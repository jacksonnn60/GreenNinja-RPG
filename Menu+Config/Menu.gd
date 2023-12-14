extends Control

@onready var score_label = $MarginContainer/VBoxContainer/scoreLabel

# Called when the node enters the scene tree for the first time.

func _ready():
	var loaded_score = load_score()
	score_label.text = "Your   previous   score   is:   " + str(loaded_score)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")


func load_score():
	var config = ConfigFile.new()
	if config.load("res://Menu+Config/config.cfg") == OK:
		var score = config.get_value("Player", "score", 0)
		return score
	else:
		return 0
