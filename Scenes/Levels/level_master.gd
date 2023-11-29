extends Node2D


func _process(_delta):
	reset()

func reset():
	if Global.player_health == 0:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		Global.player_health = 100
