extends CharacterBody2D
class_name Player

var move_speed: float = 175
var direction: Vector2 = Vector2.ZERO
var attack_cd_time: float = 0.6
var invincible_cd_time: float = 1.0
var can_attack: bool = true
var attacking: bool = false
var _is_invincible: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_cd: Timer = $AttackCoolDown
@onready var invincible_cd: Timer = $InvincibleCoolDown
@onready var sprite: Sprite2D = $Sprite2D
@onready var sound: AudioStreamPlayer = $Sword

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	update_animation_parameters()
	
func _physics_process(_delta):
	movement()
	if attacking:
		attack()
	
func movement():
	# Get Input Direction
	direction = Input.get_vector("Left","Right","Up","Down")
	# Update Velocity
	velocity = direction * move_speed 
	# Move and Slide
	move_and_slide()

func attack():
	move_speed = 0
	can_attack = false
	attack_cd.start(attack_cd_time)
	print("attacking")
	
func hit():
	if _is_invincible:
		return
		
	Global.player_health -= 10
	print(Global.player_health)
	
	if Global.player_health <= 0:
		die()
	else:
		blink()
		_is_invincible = true
		invincible_cd.start(invincible_cd_time)

func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/Idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/Idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("Attack"):
		attacking = true
		animation_tree["parameters/conditions/attack"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		attacking = false
		animation_tree["parameters/conditions/attack"] = false
	if(direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Attacking/blend_position"] = direction
		animation_tree["parameters/Move/blend_position"] = direction

func blink():
	sprite.material.set_shader_parameter("progress", 1)

func _on_invincible_cool_down_timeout():
	_is_invincible = false
	sprite.material.set_shader_parameter("progress", 0)

func _on_attack_cool_down_timeout():
	can_attack = true
	move_speed = 175

func die():
	queue_free()
