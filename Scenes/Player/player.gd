extends CharacterBody2D

@export var move_speed: float = 100

@onready var helmet_on = $armor
@onready var helmet_off = $armorless

var helmet = false

func _physics_process(_delta):
	movement()
	equip()
	

func equip():
	# This Function will handle all the equipement.
	if Input.is_action_just_pressed("Interact"):
		helmet = true
	if helmet == true:
		helmet_on.show()
		helmet_off.hide()
	else:
		helmet_on.hide()
		helmet_off.show()

func hit():
	pass

func movement():
		# Get Input Direction
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	# Update Velocity
	velocity = input_direction * move_speed
	# Move and Slide
	move_and_slide()

func dodge():
	# This function handles the dodge 
	pass
func attack():
	# This function handle the attack
	pass

