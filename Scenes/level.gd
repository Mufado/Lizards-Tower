extends Node2D

var axe_scene: PackedScene = preload("res://Scenes/Player/Items/trowing_axe.tscn")

func _on_player_trow_axe(pos, aim_direction):
	var axe = axe_scene.instantiate() as RigidBody2D
	axe.position = pos
	axe.linear_velocity = aim_direction * axe.speed
	$Trowables.add_child(axe,true)
