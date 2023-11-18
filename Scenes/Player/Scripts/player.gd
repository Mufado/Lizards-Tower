extends CharacterBody2D

var move_speed: float = 200

var direction: Vector2 = Vector2.ZERO
var attack_cd_time: float = 1.0
var invicible_cd_time: float = 1.0
var can_attack: bool = true
var can_move: bool = true

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_cd: Timer = $AttackCoolDown
@onready var invincible_cd: Timer = $InvincibleCoolDown
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	update_animation_parameters()
	
func _physics_process(_delta):
	movement()

func movement():
	if can_move:
		# Get Input Direction
		direction = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")).normalized()
		# Update Velocity
		velocity = direction * move_speed 
		# Move and Slide
		move_and_slide()

func dodge():
	# This function handles the dodge 
	pass

func attack(body):
	move_speed = 100
	if can_attack:
		can_attack = false
		attack_cd.start(attack_cd_time)
		if "hit" in body:
			body.hit()
	
func hit():
	invincible_cd.start(invicible_cd_time)
	Global.player_health -= 10
	blink()
	if Global.player_attack >= 0:
		die()

func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/Idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/Idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("Attack"):
		animation_tree["parameters/conditions/attack"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/attack"] = false
		
	if(direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Attacking/blend_position"] = direction
		animation_tree["parameters/Move/blend_position"] = direction

func blink():
	sprite.material.set_shader_parameter("progress", 1)


func _on_invincible_cool_down_timeout():
	sprite.material.set_shader_parameter("progress", 0)

func _on_attack_cool_down_timeout():
	can_attack = true

func die():
	queue_free()
