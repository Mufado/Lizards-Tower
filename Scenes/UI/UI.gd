extends CanvasLayer
class_name UI

@onready var Player_Health = $Control/MarginContainer/VBoxContainer/PlayerHealth

func _process(_delta):
	_update_player_health()

func _update_player_health():
	Player_Health.value = Global.player_health


