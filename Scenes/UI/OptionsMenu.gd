extends Control

enum OptionsMenuTypes{
	PAUSE,
	WIN,
	LOSE	
}

@onready var label_title = $LabelTitle
@onready var principal_action = $Panel/MarginContainer/VBoxContainer/PrincipalAction

var OptionsTypeSelected = OptionsMenuTypes.PAUSE

		
func _ready():
	visible = false

func _show_options(type):
	OptionsTypeSelected = type
	get_tree().paused = true
	
	match OptionsTypeSelected:
		OptionsMenuTypes.PAUSE:
			label_title.text = "PAUSED"
			principal_action.text = "Resume"
			
		OptionsMenuTypes.WIN:
			label_title.text = "YOU WIN"
			principal_action.text = "Restart"
		
		OptionsMenuTypes.LOSE:
			label_title.text = "GAME OVER"
			principal_action.text = "Restart"
		
	
	visible = true		
	principal_action.grab_focus()

	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_show_options(OptionsMenuTypes.PAUSE)


func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_principal_action_pressed():
	get_tree().paused = false
	visible = false				
			
	if OptionsTypeSelected == OptionsMenuTypes.WIN || OptionsTypeSelected == OptionsMenuTypes.LOSE:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
