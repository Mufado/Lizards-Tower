extends StaticBody2D

var hit_counter: int = 30

@onready var animation = $AnimationPlayer

func take_damage(damage: int):
	if hit_counter > 0:
		hit_counter -= damage
		animation.play("Hit")
func explode():
	animation.play("Explosion")
