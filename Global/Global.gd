extends Node

enum PlataformToExport
{
	WINDOWS,
	HTML
}

var PlataformToExportSelected = PlataformToExport.HTML
var is_start_game = true

# Player Stats
var player_max_health = 100
var player_health = 100
var player_attack = 25

# Sound Volume
var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0

var game_levels : Array[String] = [
	"level_0",	
	"level_1",
	"level_2"
]
var current_level = 0

func _goto_next_level():
	current_level += 1
	_goto_current_level()
	
func _goto_current_level():
	if game_levels.size() == current_level:
		get_tree().change_scene_to_file("res://Scenes/UI/CreditsScreen.tscn")
		
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/" + game_levels[current_level] + ".tscn")
	
func _goto_fist_level():
	current_level = 0
	_goto_current_level()
	
func _goto_last_level():
	current_level = game_levels.count(1) - 1
	_goto_current_level()
	
func _goto_splash_screen():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
