extends CharacterBody2D
class_name Player

var move_speed: float = 155
var direction: Vector2 = Vector2.ZERO
var invincible_cd_time: float = 1.0
var attacking: bool = false
var _is_invincible: bool = false
var knockback_modifier: float = 2.0

@onready var invincible_cd: Timer = $InvincibleCoolDown
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var collision_shape = $CollisionShape2D
@onready var hit_flash = $HitFlash



func _ready():
	anim_tree.active = true

func _physics_process(_delta):
	if !attacking:
		velocity = direction * move_speed
		
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
func _process(_delta):
	direction = Input.get_vector("Left","Right","Up","Down")
	
	if direction != Vector2.ZERO and not attacking:
		set_movement(true)
		update_blend_position()
	else:
		set_movement(false)
	if Input.is_action_just_pressed("Attack"):
		set_attack(true)
		
func set_attack(value = false):
	attacking = value
	anim_tree["parameters/conditions/attacking"] = value
	
func set_movement(value):
	anim_tree["parameters/conditions/is_moving"] = value
	anim_tree["parameters/conditions/idle"] = not value
	
func update_blend_position():
	anim_tree["parameters/Idle/blend_position"] = direction
	anim_tree["parameters/Move/blend_position"] = direction
	anim_tree["parameters/Attack/blend_position"] = direction
	
func hit():
	blink()
	if _is_invincible:
		return
		
	Global.player_health -= 10
	print(Global.player_health)
	

	
	if Global.player_health <= 0:
		die()
	else:
		knockback()
		_is_invincible = true
		invincible_cd.start(invincible_cd_time)
		
func knockback():
	pass
	
func blink():
	hit_flash.play("flash")
	
func _on_invincible_cool_down_timeout():
	_is_invincible = false
	

func die():
	queue_free()

func _on_hurt_box_body_entered(_body):
	hit()
