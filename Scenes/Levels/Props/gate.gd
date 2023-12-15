extends Node2D

var opened = false
var can_open = false

@export_file var dest_scene
@export var auto_destiny:bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(_delta):
	if !opened and can_open:
		if Input.is_action_just_pressed("Interact"):
			_open_gate()
	if opened:
		if Input.is_action_just_pressed("Interact"):
			_goto_destiny()

func _open_gate():
	anim.play("Opening")
	sfx.play()
	await anim.animation_finished
	opened = true
	anim.play("Open")
	
func _goto_destiny():
	if auto_destiny:
		Global._goto_next_level()
	else:
		get_tree().change_scene_to_file(dest_scene)	
		


func _on_activation_area_body_entered(_body):
	if auto_destiny:
		if opened:
			_goto_destiny()
	else:
		can_open = true

func _on_activation_area_body_exited(_body):
	can_open = false
