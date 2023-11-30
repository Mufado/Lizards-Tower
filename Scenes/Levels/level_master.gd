extends Node2D

@onready var options_menu = $UI/OptionsMenu
@onready var lizard = $Entities/Lizard

@export var _Enemys:Array[Lizard]


func _process(_delta):
	reset()

func reset():
	if Global.player_health == 0:
		options_menu._show_options(options_menu.OptionsMenuTypes.LOSE)
		Global.player_health = 100
	
	var i=0
	for enemy in _Enemys:
		if enemy==null:
			i = i + 1
		
	if i == _Enemys.size():
		options_menu._show_options(options_menu.OptionsMenuTypes.WIN)
		Global.player_health = 100	
