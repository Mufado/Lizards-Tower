extends Node

enum PlataformToExport
{
	WINDOWS,
	HTML
}

var PlataformToExportSelected = PlataformToExport.WINDOWS
var is_start_game = true

# Player Stats
var player_max_health = 100
var player_health = 100
var player_attack = 25

# Sound Volume
var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0
