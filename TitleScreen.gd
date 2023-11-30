extends Control

@onready var title_song = $TitleSong
@onready var credits_screen = $CreditsScreen
@onready var anim = $AnimationPlayer

@onready var play = $Panel/MarginContainer/VBoxContainer/Play
@onready var credits = $Panel/MarginContainer/VBoxContainer/Credits


func _ready():
	get_tree().paused = false
	play.grab_focus()
	title_song.playing = true
	anim.play("AninTitleScreen")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_credit_pressed():
	credits_screen.visible = true
	credits_screen.close.grab_focus()
	credits_screen.credits = credits
	
func _on_exit_pressed():
	get_tree().quit()


