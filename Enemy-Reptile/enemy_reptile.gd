extends CharacterBody2D

signal didDie

const speed = 50
@export var limit = 0.5
@onready var moveAnimation = $AnimationPlayer
@onready var effectAnimation = $EffectAnimation
@onready var hurtTimer = $hurtTimer
@onready var hitBox = $hitBox
@export var knockbackPower = 1500

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
var player: Node2D

var isHurt = false
var health = 2

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _ready():
	make_path()

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

func make_path() -> void: 
	if player == null: return
	navigation_agent.target_position = player.global_position

func updateVelocity():
	if player == null: return
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * speed
	move_and_slide()

func animate_hurt():
	effectAnimation.play("hurt")
	hurtTimer.start()
	await hurtTimer.timeout
	effectAnimation.play("RESET")

func _physics_process(delta):
	updateVelocity()
	updateAnimation()

func _on_hit_box_area_entered(area: Area2D):
	if area.name.contains("Weapon") && player.isAttacking && !isHurt:
		print(area.get_parent())
		knockback(area.get_parent().get_parent().velocity)
#		isHurt = true
		animate_hurt()
		if health == 0:
			print("Enemy killed !")
#				#moveAnimation.play("killed")
#				#await moveAnimation.animation_finished
			didDie.emit()
			queue_free()
		else: 
			health -= 1
#			print(health)
#		isHurt = false


func _on_timer_timeout():
	make_path()
