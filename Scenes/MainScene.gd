extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $TileMap/Player
@onready var tileMap = $TileMap

var reptile_enemy = preload("res://Enemy-Reptile/enemy-reptile.tscn")
var sword_item = preload("res://Collectables/Katana-Item.tscn")
var medipack_item = preload("res://Collectables/Medipack-Item.tscn")
var enemiesHasBeenAdded = false
var swordHasBeenAdded = false
var medipacksHasBeedAdded = false

var score: int = 0
var round: int = 1

func randomize_object_position():
	print(tileMap)
	var tile_size = tileMap.tile_set.tile_size
	var map_size = tileMap.get_used_rect().size
	var max_x = map_size.x * tile_size.x
	var max_y = map_size.y * tile_size.y
	var new_x = randf_range(0, max_x - tile_size.x)
	var new_y = randf_range(0, max_y - tile_size.y)
	return Vector2(new_x, new_y)

# Spawn

func spawn_enemies(): 
	if enemiesHasBeenAdded: return
	for i in range(0, randi_range(1, 10)):
		var enemy = reptile_enemy.instantiate()
		enemy.position = randomize_object_position()
		add_child(enemy)
	enemiesHasBeenAdded = true

func spawn_swords():
	if swordHasBeenAdded: return
	for i in range(0, randi_range(1, 10)):
		var sword = sword_item.instantiate()
		sword.position = randomize_object_position()
		sword.name = "katana_item_collectable" + str(i)
		add_child(sword)
	swordHasBeenAdded = true
	
func spawn_medipacks():
	if medipacksHasBeedAdded: return
	for i in range(0, randi_range(1, 10)):
		var medipack = medipack_item.instantiate()
		medipack.position = randomize_object_position()
		medipack.name = "medipack_item_collectable" + str(i)
		add_child(medipack)
	medipacksHasBeedAdded = true

func play_background_music():
	if !$MainASP.playing:
		$MainASP.play()

func _ready():
	play_background_music()
	spawn_enemies()
	spawn_medipacks()
	spawn_swords()
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass