extends Area2D

var entered = false
@export_file var dest_scene

func _on_body_entered(_body: CharacterBody2D):
	entered = true

func _on_body_exited(_body):
	entered = false

func _process(_delta):
	if entered:
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file(dest_scene)
