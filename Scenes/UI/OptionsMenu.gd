extends CanvasLayer

enum OptionsMenuTypes{
	PAUSE,
	WIN,
	LOSE	
}

@onready var label_title = $Control/LabelTitle
@onready var principal_action = $Control/Panel/MarginContainer/VBoxContainer/PrincipalAction
@onready var quit = $Control/Panel/MarginContainer/VBoxContainer/Quit


var OptionsTypeSelected = OptionsMenuTypes.PAUSE

		
func _ready():
	visible = false
	if Global.PlataformToExportSelected == Global.PlataformToExport.WINDOWS:
		quit.visible=true
	else:
		quit.visible=false

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
	if event.is_action_pressed("pause"):
		_show_options(OptionsMenuTypes.PAUSE)


func _on_main_menu_pressed():
	Global._goto_splash_screen()


func _on_principal_action_pressed():
	get_tree().paused = false
	visible = false					
	
	if OptionsTypeSelected == OptionsMenuTypes.WIN || OptionsTypeSelected == OptionsMenuTypes.LOSE:
		Global._goto_fist_level() # get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
