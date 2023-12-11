extends Area2D

func _on_body_entered(body):
	print("body entered!")
	if body is Player:
		print("player")
		if Global.player_health < Global.player_max_health:
			Global.player_health += 10
		queue_free()
