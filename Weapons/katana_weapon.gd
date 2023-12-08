extends Area2D

@onready var animation = $AnimationPlayer

func broke():
	animation.play("broken")
