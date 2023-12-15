extends Control

@onready var title_song = $TitleSong
@onready var credits_screen = $UI/CreditsScreen
@onready var anim = $AnimationPlayer

@onready var play = $UI/Panel/MarginContainer/VBoxContainer/Play
@onready var credits = $UI/Panel/MarginContainer/VBoxContainer/Credits
@onready var quit = $UI/Panel/MarginContainer/VBoxContainer/Quit


func _ready():
	get_tree().paused = false
	play.grab_focus()
	title_song.playing = true
	anim.play("AninTitleScreen")
	
	if Global.PlataformToExportSelected == Global.PlataformToExport.WINDOWS:
		quit.visible=true
	else:
		quit.visible=false
		
func _on_start_pressed():
	Global._goto_fist_level()

func _on_credit_pressed():
	credits_screen.visible = true
	credits_screen.close.grab_focus()
	credits_screen.credits = credits
	
func _on_exit_pressed():
	get_tree().quit()


