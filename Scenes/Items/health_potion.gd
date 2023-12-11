extends Area2D

func _on_body_entered(body):
	if body is Player:
		if Global.player_health < Global.player_max_health:
			Global.player_health += 10
		queue_free()
