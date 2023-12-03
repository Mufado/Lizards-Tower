extends CharacterBody2D
class_name Lizard

var angle_betwenn_rays := deg_to_rad(20.0)
var view_angle := deg_to_rad(120.0)
var max_view_distance := 200.0
var SPEED = 125.0
var direction: Vector2 = Vector2.ZERO
var is_in_range_to_attack: bool = false
var is_chasing: bool = false
var can_attack: bool = false
var health: int = 60
var is_invincible: bool = false
var does_see_player := target
var player_in_area: bool

@export var _nav_agent_target: Node2D

@onready var sprite = $AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _anim_tree := $AnimationTree
@onready var _raycast := $RayCast2D
@onready var _state_machine: AnimationNodeStateMachinePlayback = _anim_tree.get("parameters/playback")
@onready var target: Player = null
@onready var hit_flash = $HitFlash
@onready var life_bar = $LifeBar/LifeBar
@onready var invincible_cd = $InvincibleCD
@onready var invincible_cd_time: float = 0.8
@onready var attack_cd = $AttackCD
@onready var attack_cd_timer: float = 0.5
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

func _physics_process(_delta: float) -> void:
	if player_in_area:
		var cast_count := int(view_angle / angle_betwenn_rays) + 1
		for index in cast_count:
			var cast_vector := (
				max_view_distance
				* Vector2.UP.rotated(angle_betwenn_rays * (index - cast_count / 2.0)
			))
			_raycast.set_target_position = cast_vector
			_raycast.force_raycast_update()
			if _raycast.is_colliding() and _raycast.get_collider() is Player:
				target = _raycast.get_collider()
		var _does_see_player := target != null
		
	_update_life_bar()
	if is_chasing:
		_update_pathfind()
		_manage_attack()
	move_and_slide()


func _update_pathfind():
<<<<<<< Updated upstream
	if _is_viewing_player():
		_nav_agent.set_target_position(_nav_agent_target.get_node("Target").global_position)
=======
	if does_see_player:
		_nav_agent.set_target_position(_nav_agent_target.get_node("CollisionShape2D").global_position)
>>>>>>> Stashed changes
		direction = (_nav_agent.get_next_path_position() - global_position).normalized()


func _manage_attack():
<<<<<<< Updated upstream
	if is_in_range_to_attack:
=======
	if is_in_range_to_attack and does_see_player:
		velocity = direction * 0
>>>>>>> Stashed changes
		var attack_direction = _get_attack_direction();

		if abs(attack_direction.x) <= 3.0 || abs(attack_direction.y) <= 4.0:
			_attack(attack_direction)
		elif _state_machine.get_current_node() == "Attack":
			direction = Vector2(attack_direction.x, 0.0) if abs(attack_direction.x) < abs(attack_direction.y) else Vector2(0.0, attack_direction.y)
			_repositionate()

	elif _state_machine.get_current_node() == "Attack":
		_state_machine.travel("ChasePlayer")

	else:
<<<<<<< Updated upstream
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

=======
		_chase_player()


>>>>>>> Stashed changes

func _blink():
	hit_flash.play("flash")
	
func _attack(attack_direction: Vector2):
	_state_machine.travel("Attack")
	_anim_tree.set("parameters/Attack/blend_position", attack_direction)
	velocity = Vector2.ZERO * 0

func _chase_player():
	if is_chasing and not is_in_range_to_attack:
		_state_machine.travel("ChasePlayer")
		_anim_tree.set("parameters/ChasePlayer/blend_position", direction)
		velocity = direction * SPEED

func _get_attack_direction():
	return target.global_position

func _on_attack_range_body_entered(_body):
#	is_in_range_to_attack = true
	pass
func _on_attack_range_body_exited(_body):
#	is_in_range_to_attack = false
	pass

func _on_invincible_cd_timeout():
	is_invincible = false

func _update_life_bar():
	life_bar.value = health
	if health == life_bar.max_value:
		life_bar.visible = false
	else:
		life_bar.visible = true


func _on_attack_cd_timeout():
	pass # Replace with function body.


func _on_notice_area_body_entered(_body):
	player_in_area = true

func _on_notice_area_body_exited(_body):
	player_in_area = false
	



