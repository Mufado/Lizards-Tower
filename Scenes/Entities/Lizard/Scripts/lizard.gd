extends CharacterBody2D
class_name Lizard

const ANGLE_BETWEEN_RAYS = deg_to_rad(20.0)
const SPEED = 135.0
const VIEW_ANGLE = deg_to_rad(120.0)
const VIEW_DISTANCE = 200.0
const RAYCAST_UPDATE_QUANTITY = int(VIEW_ANGLE / ANGLE_BETWEEN_RAYS) + 1

var direction: Vector2 = Vector2.ZERO
var is_in_range_to_attack: bool = false
var is_chasing: bool = false
var health: int = 60
var is_invincible: bool = false

@export var _nav_agent_target: Node2D

@onready var sprite = $AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _anim_tree := $AnimationTree
@onready var _raycast := $RayCast2D
@onready var _state_machine: AnimationNodeStateMachinePlayback = _anim_tree.get("parameters/playback")
@onready var _player_hurt_box = _nav_agent_target.get_node("CollisionShape2D")
@onready var hit_flash = $HitFlash
@onready var life_bar = $LifeBar/LifeBar
@onready var invincible_cd = $InvincibleCD
@onready var invincible_cd_time: float = 0.8
@onready var hurt_sound = $HurtSound


func take_damage(damage: int):
	health -= damage
	hurt_sound.play()
	if health <= 0:
		queue_free()
		return

	is_invincible = true
	invincible_cd.start(invincible_cd_time)
	_blink()

func _physics_process(_delta):
	_update_life_bar()
	if is_chasing:
		_update_pathfind()
		_manage_attack()
	else:
		_sweep_raycast()
	move_and_slide()


func _update_pathfind():
	if _is_viewing_player():
		_nav_agent.set_target_position(_nav_agent_target.get_node("Target").global_position)
		direction = (_nav_agent.get_next_path_position() - global_position).normalized()
	else:
		velocity = Vector2.ZERO

func _is_viewing_player():
	if _player_hurt_box != null:
		_raycast.set_target_position(to_local(_player_hurt_box.global_position))

	_raycast.force_raycast_update()
	
	if(!_raycast.is_colliding() || !_raycast.get_collider() is Player):
		return false

	return true

func _manage_attack():
	if is_in_range_to_attack:
		var attack_direction = _get_attack_direction();

		if abs(attack_direction.x) <= 3.0 || abs(attack_direction.y) <= 4.0:
			_attack(attack_direction)
		elif _state_machine.get_current_node() == "Attack":
			direction = Vector2(attack_direction.x, 0.0) if abs(attack_direction.x) < abs(attack_direction.y) else Vector2(0.0, attack_direction.y)
			_repositionate()

	elif _state_machine.get_current_node() == "Attack":
		_state_machine.travel("ChasePlayer")

	else:
		_anim_tree.set("parameters/ChasePlayer/blend_position", direction)
		velocity = direction * SPEED


func _sweep_raycast():
	for index in RAYCAST_UPDATE_QUANTITY:
		var cast_vector := (
			VIEW_DISTANCE *
			Vector2.DOWN.rotated (
				ANGLE_BETWEEN_RAYS *
				(index - RAYCAST_UPDATE_QUANTITY / 2.0)
			)
		)

		_raycast.set_target_position(cast_vector)
		_raycast.force_raycast_update()

		if _raycast.is_colliding() && _raycast.get_collider() is Player:
			_anim_tree.set("parameters/ChasePlayer/blend_position", direction)
			_state_machine.travel("ChasePlayer")
			is_chasing = true
			break


func _blink():
	hit_flash.play("flash")
	
func _attack(attack_direction: Vector2):
	_state_machine.travel("Attack")
	_anim_tree.set("parameters/Attack/blend_position", attack_direction)
	velocity = Vector2.ZERO

func _repositionate():
	_state_machine.travel("ChasePlayer")
	_anim_tree.set("parameters/ChasePlayer/blend_position", direction)
	velocity = direction * SPEED

func _get_attack_direction():
	return _player_hurt_box.global_position - global_position


func _on_attack_range_body_entered(_body):
	is_in_range_to_attack = true

func _on_attack_range_body_exited(_body):
	is_in_range_to_attack = false


func _on_invincible_cd_timeout():
	is_invincible = false

func _update_life_bar():
	life_bar.value = health
	if health == life_bar.max_value:
		life_bar.visible = false
	else:
		life_bar.visible = true
