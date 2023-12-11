extends Control

#@onready var credits_screen = $CreditsScreen
@onready var close = $Panel/Close

var credits

# Called when the node enters the scene tree for the first time.
func _ready():
	close.grab_focus()

 
func _on_close_pressed():
	visible = false 
	credits.grab_focus()
