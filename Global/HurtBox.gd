class_name HurtBox
extends Area2D

#func _init() -> void:
#	collision_layer = 128
#	collision_mask = 64

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null || hitbox.owner == owner:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
