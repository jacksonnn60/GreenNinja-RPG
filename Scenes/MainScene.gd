extends Node2D

@onready var roundLabel = $CanvasLayer/roundLabel
@onready var scoreLabel = $CanvasLayer/scoreLabel
@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $TileMap/Player
@onready var tileMap: TileMap = $TileMap

var reptile_enemy = preload("res://Enemy-Reptile/enemy-reptile.tscn")
var sword_item = preload("res://Collectables/Katana-Item.tscn")
var medipack_item = preload("res://Collectables/Medipack-Item.tscn")

var not_empty_positions = []

var enemies_alive: int = 0
var score: int = 0
var round: int = 0

# TODO: FINISH CHECKING FREE SPAWN POS
func get_not_empty_positions():
	var not_empty_positions = [] 
	for layer in $TileMap.get_layers_count():
		var cells = $TileMap.get_used_cells(layer)
		for cell in cells:
			not_empty_positions.append(Vector2(cell.x * 16, cell.y * 16))
	return not_empty_positions

func randomize_object_spawn_position():
	var new_x = randi_range(0, 592)
	var new_y = randi_range(-144, 255)
	var position = Vector2(new_x, new_y)
	if position in not_empty_positions:
		return randomize_object_spawn_position()
	return position

# Spawn

func start_new_round():
	for child in tileMap.get_children():
		if child.name.contains("item_collectable"):
			print("Clearing item: ", child.name)
			child.queue_free()
	round += 1
	roundLabel.update_round(round)
	enemies_alive = round * 2
	spawn_enemies()
	spawn_medipacks()
	spawn_swords()

func spawn_enemies(): 
	for i in range(0, round * 2):
		var enemy = reptile_enemy.instantiate()
		enemy.player = player
		enemy.didDie.connect(update_score)
		enemy.position = randomize_object_spawn_position()
		enemy.name = "reptile_enemy" + str(i)
		add_child(enemy)

func spawn_swords():
	for i in range(0, round * 3):
		var sword = sword_item.instantiate()
		sword.position = randomize_object_spawn_position()
		sword.name = "katana_item_collectable" + str(i)
		add_child(sword)
	
func spawn_medipacks():
	for i in range(0, round * 2):
		var medipack = medipack_item.instantiate()
		medipack.position = randomize_object_spawn_position()
		medipack.name = "medipack_item_collectable" + str(i)
		add_child(medipack)

func update_score():
	score += 1
	enemies_alive -= 1
	scoreLabel.update_score(score)

func play_background_music():
	pass
#	if !$MainASP.playing:
#		$MainASP.play()

func _ready():
	not_empty_positions = get_not_empty_positions()
	play_background_music()
	start_new_round()
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	player.didDie.connect(game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemies_alive <= 0:
		start_new_round()

func _on_main_asp_finished():
	play_background_music()

func game_over():
	save_score(score)
	get_tree().change_scene_to_file("res://Menu+Config/Menu.tscn")

func save_score(score):
	var config = ConfigFile.new()
	if config.load("res://Menu+Config/config.cfg") == OK:
		config.set_value("Player", "score", score)
	else:
		config.set_value("Player", "score", score)
	config.save("res://Menu+Config/config.cfg")
