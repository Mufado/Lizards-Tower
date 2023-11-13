extends CharacterBody2D


@export var move_speed: float = 80.0

var direction: Vector2 = Vector2.ZERO
var attack_cd_time: float = 0.5
var invicible_cd_time: float = 2.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_cd: Timer = $AttackCoolDown
@onready var invincible_cd: Timer = $InvincibleCoolDown

func _ready():
	animation_tree.active = true
	
func _process(_delta):
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

func hit():
	pass

func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/Idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/Idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("Attack"):
		animation_tree["parameters/conditions/attack"] = true
	else:
		animation_tree["parameters/conditions/attack"] = false
		
	if(direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Attacking/blend_position"] = direction
		animation_tree["parameters/Move/blend_position"] = direction
