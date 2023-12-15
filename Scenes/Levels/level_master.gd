extends Node2D

@onready var options_menu = $OptionsMenu
@onready var enemies = $Entities/Enemies
@onready var gate = $Props/Structures/Gate

@export var player:Player

@export var enemies_blocks_gate:bool = false
var gate_opened:bool = false

func _process(_delta):
	reset()
	_verify_if_can_open_gate()

func reset():
	if Global.player_health <= 0:
		options_menu._show_options(options_menu.OptionsMenuTypes.LOSE)
		Global.player_health = 100
	

func _verify_if_can_open_gate():
	if !gate_opened && enemies_blocks_gate && enemies.get_child_count(false)<=0:
		if player != null:			
			player.camera._show_object(gate)
		gate_opened = true
		gate._open_gate()
	
	
	
