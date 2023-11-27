extends Node2D

var opened = false
var can_open = false

@export_file var dest_scene

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(_delta):
	if !opened and can_open:
		if Input.is_action_just_pressed("Interact"):
			anim.play("Opening")
			sfx.play()
			await anim.animation_finished
			opened = true
	if opened:
		anim.play("Open")
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file(dest_scene)


func _on_activation_area_body_entered(_body):
	can_open = true

func _on_activation_area_body_exited(_body):
	can_open = false
