extends Control

@onready var title_song = $TitleSong

func _ready():
	title_song.playing = true

func _on_exit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
 
