extends CharacterBody2D

@export var move_speed: float = 100

@onready var animation_tree : AnimationTree = $AnimationTree

var direction: Vector2 = Vector2.ZERO

func _process(delta):
	update_animation_parameters()
	
func _physics_process(_delta):
	movement()
	
func movement():
	# Get Input Direction
	direction = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"),
	Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	# Update Velocity
	velocity = direction * move_speed
	# Move and Slide
	move_and_slide()

func dodge():
	# This function handles the dodge 
	pass
func attack():
	# This function handle the attack
	pass

func update_animation_parameters():
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
