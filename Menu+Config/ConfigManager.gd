class_name Config_Manager extends Node

var config = ConfigFile.new()

var config_path = "res://Menu+Config/Score_Config.cfg"
var player_section = "Score"
var last_score_key = "last"
var top_score_key = "top"

func save_score(score):
	if config.load(config_path) == OK:
		print("Writing last score...")
		config.set_value(player_section, last_score_key, score)
		config.save(config_path)
	else:
		config.save(config_path)
		save_score(score)
		
func save_top_score_if_reached(score):
	if config.load(config_path) == OK  && score > load_last_score():
		print("Writing top score...")
		config.set_value(player_section, top_score_key, score)
		config.save(config_path)
	else:
		config.save(config_path)
		save_score(score)

func load_last_score():
	if config.load(config_path) == OK:
		var score = config.get_value(player_section, last_score_key, 0)
		return score
	return 0

func load_top_score():
	if config.load(config_path) == OK:
		var score = config.get_value(player_section, top_score_key, 0)
		return score
	return 0
