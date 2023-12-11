extends StaticBody2D
class_name Props

var hit_counter: int = 20

@onready var animation = $AnimationPlayer
@onready var hit_sound = $HitSound
@onready var destruction_sound = $DestructionSound

func take_damage(damage: int):
	hit_sound.play()
	if hit_counter > 0:
		hit_counter -= damage
		animation.play("Hit")
	else:
		destruction_sound.play()
		animation.play("Explosion")

