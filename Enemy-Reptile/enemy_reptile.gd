extends CharacterBody2D

signal didDie

@export var speed = 20
@export var limit = 0.5
@onready var moveAnimation = $AnimationPlayer
@onready var effectAnimation = $EffectAnimation
@onready var hurtTimer = $hurtTimer
@onready var hitBox = $hitBox
var player

var isHurt = false
var health = 2

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
	updateAnimation()
	
	for area in hitBox.get_overlapping_areas():
		if area.name.contains("Katana-Weapon") && player.isAttacking && !isHurt:
			isHurt = true
			effectAnimation.play("hurt")
			hurtTimer.start()
			await hurtTimer.timeout
			effectAnimation.play("RESET")
			if health == 0: 
				didDie.emit()
				queue_free()
			else: health -= 1
			isHurt = false
