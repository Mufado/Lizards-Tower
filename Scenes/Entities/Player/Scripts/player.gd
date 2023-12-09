extends CharacterBody2D
class_name Player

var move_speed: float = 155
var direction: Vector2 = Vector2.ZERO
var invincible_cd_time: float = 1.0
var _is_attacking: bool = false
var _is_invincible: bool = false

@onready var invincible_cd: Timer = $InvincibleCoolDown
@onready var sprite: Sprite2D = $Sprite2D
@onready var sound: AudioStreamPlayer2D = $Sword
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hit_flash: AnimationPlayer = $HitFlash
@onready var _attack_delay: Timer = $AttackDelay
@onready var hurtsound = $Hurtsound
@onready var camera = $Camera2D

func _ready():
	anim_tree.active = true

func _physics_process(_delta):
	if !_is_attacking:
		velocity = direction * move_speed
		
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
func _process(_delta):
	direction = Input.get_vector("Left","Right","Up","Down")
	
	if Input.is_action_just_pressed("Attack") && !_is_attacking:
		anim_tree.get("parameters/playback").travel("Attack")
		_is_attacking = true
		_attack_delay.start()
	
	if direction != Vector2.ZERO and not _is_attacking:
		set_movement(true)
		update_blend_position()
	else:
		set_movement(false)


func set_movement(value):
	anim_tree["parameters/conditions/is_moving"] = value
	anim_tree["parameters/conditions/idle"] = not value
	
func update_blend_position():
	anim_tree["parameters/Idle/blend_position"] = direction
	anim_tree["parameters/Move/blend_position"] = direction
	anim_tree["parameters/Attack/blend_position"] = direction
	
func take_damage(damage: int):
	if _is_invincible:
		return
	Global.player_health -= damage * randf_range(0.75,2.0)
	
	if Global.player_health > 0:
		camera.camerashake.emit()
		hurtsound.play()
		hit_flash.play("flash")
		_is_invincible = true
		invincible_cd.start(invincible_cd_time)

func _on_invincible_cool_down_timeout():
	_is_invincible = false

func _on_attack_delay_timeout():
	_is_attacking = false
