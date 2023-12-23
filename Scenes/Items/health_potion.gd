extends RigidBody2D
class_name HealthPotion


func _on_timer_timeout():
	pass

func _on_area_2d_body_entered(body):
	if body is Player:
		if Global.player_health < Global.player_max_health:
			Global.player_health += 20 * randf_range(1, 1.5)
		queue_free()
