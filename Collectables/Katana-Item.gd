extends "res://Collectables/collectable.gd"

@onready var animations = $AnimationPlayer

func collect():
	animations.play("picked")
	await animations.animation_finished
	super.collect()
