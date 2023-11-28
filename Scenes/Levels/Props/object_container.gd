extends StaticBody2D

var hit_counter: int = 3

@onready var animation = $AnimationPlayer



func hit():
	if hit_counter > 0:
		hit_counter -= 1
		animation.play("Hit")
func explode():
	animation.play("Explosion")

func _on_hurt_box_body_entered(_body):
	print("being hit")
	hit()
