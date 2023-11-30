extends Node2D

@onready var options_menu = $OptionsMenu


func _process(_delta):
	reset()

func reset():
	if Global.player_health <= 0:
		options_menu._show_options(options_menu.OptionsMenuTypes.LOSE)
		Global.player_health = 100
	

