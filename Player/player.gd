extends CharacterBody2D

signal healthChanged

@export var maxHealth = 3
@export var speed: int = 75
@onready var playerAnimation = $AnimationPlayer
@onready var hitBox = $hitBox
@onready var effectsAnimations = $EffectAnimation
@onready var weapon = $Weapon
@onready var hurtTimer = $timer
@onready var healTimer = $healTimer
@onready var currentHealth: int = maxHealth
@export var knockbackPower = 500

var isHurt = false

var hasKatana = true
var katanaHealth = 3

var isAttacking = false

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
	if Input.is_action_just_pressed("attack") && hasKatana:
		attack()

# KATANA MANAGEMENT:

func updateKatana():
	if hasKatana && katanaHealth <= 0: removeKatana()
	elif !hasKatana: createNewKatana()
	else: return

func removeKatana():
	var katana = weapon.get_child(0)
	katana.visible = false
	hasKatana = false

func createNewKatana():
	var katana = weapon.get_child(0)
	katana.visible = true
	katanaHealth = 3
	hasKatana = true

# ---------------------

func attack():
	if !$AttackASP.playing: $AttackASP.play()
	
	isAttacking = true
	playerAnimation.play("atack" + getDirection(velocity))
	await playerAnimation.animation_finished
	katanaHealth -= 1
	isAttacking = false
	updateKatana()

func getDirection(velocity):
	if velocity.x < 0: return "Left" 
	elif velocity.x > 0: return "Right"
	elif velocity.y < 0: return "Up"
	return "Down"

func updateAnimation():
	if isAttacking: return
	elif velocity.length() == 0 :
		playerAnimation.play("RESET")
	else:	
		playerAnimation.play("walk" + getDirection(velocity))

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()

func hurtByEnemy(area):
	isHurt = true
	if !$HitASP.playing: $HitASP.play()
	currentHealth -= 1
	if currentHealth < 0: 
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	knockback(area.get_parent().velocity)
	effectsAnimations.play("hurt")
	hurtTimer.start()
	await hurtTimer.timeout
	effectsAnimations.play("RESET")
	isHurt = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D):
	var areaName = area.name
	if areaName.contains("katana_item_collectable") && !hasKatana:
		createNewKatana()
		if !$WeaponPickupASP.playing: $WeaponPickupASP.play()
		area.collect()
	if areaName.contains("medipack_item_collectable") && currentHealth < maxHealth: 
		currentHealth += 1
		healthChanged.emit(currentHealth)
		area.collect()
		effectsAnimations.play("healed")
		$HealASP.play()
		healTimer.start()
		await healTimer.timeout
		$HealASP.stop()
		effectsAnimations.play("RESET")
	if areaName == "hitBox" && !isHurt: hurtByEnemy(area)
