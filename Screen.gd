extends CanvasLayer


@onready var full_screen = $Control/FullScreen


func _ready():		
	if Global.PlataformToExportSelected == Global.PlataformToExport.WINDOWS && Global.is_start_game==true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Global.is_start_game=false
	
	if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		full_screen.set_pressed_no_signal(true)
	else:
		full_screen.set_pressed_no_signal(false)


func _on_full_screen_pressed():
	if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		full_screen.set_pressed_no_signal(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		full_screen.set_pressed_no_signal(true)
