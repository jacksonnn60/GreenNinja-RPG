extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@onready var moveAnimation = $AnimationPlayer
@onready var effectAnimation = $EffectAnimation
@onready var hurtTimer = $hurtTimer
@onready var hitBox = $hitBox
var player

var health = 3

func _ready():
	player = get_node("../TileMap/Player")

func updateAnimation():
	if velocity.length() == 0 :
		if moveAnimation.is_playing():
			moveAnimation.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left" 
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		moveAnimation.play("walk" + direction)

func updateVelocity():
	var direction = player.position - position
	velocity = direction
	move_and_slide()
	
func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
	
	for area in hitBox.get_overlapping_areas():
		if area.name == "Katana" && player.isAttacking:
			effectAnimation.play("hurt")
			hurtTimer.start()
			await hurtTimer.timeout
			effectAnimation.play("RESET")
			if health <= 0: queue_free() 
			else: health -= 1
