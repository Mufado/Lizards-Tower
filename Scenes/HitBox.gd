class_name HitBox
extends Area2D

@export var damage: int = 10

func _init():
	collision_layer = 64
	collision_mask = 128


func _on_body_entered(body):
	if(body is Player and body.has_method("hit")):
		body.hit()
