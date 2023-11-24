extends CharacterBody2D
class_name Lizard

const ANGLE_BETWEEN_RAYS = deg_to_rad(20.0)
const SPEED = 50.0
const VIEW_ANGLE = deg_to_rad(120.0)
const VIEW_DISTANCE = 200.0
const RAYCAST_UPDATE_QUANTITY = int(VIEW_ANGLE / ANGLE_BETWEEN_RAYS) + 1

var direction: Vector2 = Vector2.ZERO
var is_in_range_to_attack: bool = false
var is_chasing: bool = false

@export var _nav_agent_target: Node2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _anim_tree := $AnimationTree
@onready var _raycast := $RayCast2D
@onready var _state_machine: AnimationNodeStateMachinePlayback = _anim_tree.get("parameters/playback")


func _physics_process(_delta):
	if is_chasing:
		_update_pathfind()
		_manage_attack()
	else:
		_sweep_raycast()

	move_and_slide()


func _update_pathfind():
	if _is_viewing_player():
		_nav_agent.set_target_position(_nav_agent_target.global_position)
		direction = (_nav_agent.get_next_path_position() - global_position).normalized()
	else:
		velocity = Vector2.ZERO

func _is_viewing_player():
	_raycast.set_target_position(to_local(_nav_agent_target.get_global_position()))
	_raycast.force_raycast_update()
	
	if(!_raycast.is_colliding() || !_raycast.get_collider() is Player):
		return false

	return true

func _manage_attack():
	
	if is_in_range_to_attack:
		direction = _get_attack_direction();

		if abs(direction.x) <= 0.15 || abs(direction.y) <= 0.15:
			_attack()
		elif _state_machine.get_current_node() == "Attack":
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
			Vector2.UP.rotated (
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


func _attack():
	_state_machine.travel("Attack")
	_anim_tree.set("parameters/Attack/blend_position", direction)
	velocity = Vector2.ZERO

func _repositionate():
	_state_machine.travel("ChasePlayer")
	_anim_tree.set("parameters/ChasePlayer/blend_position", direction)
	velocity = direction * SPEED

func _get_attack_direction():
	return (_nav_agent_target.global_position - global_position).normalized()


func _on_attack_range_body_entered(_body):
	if abs(velocity.x) < abs(velocity.y):
		velocity.x = 0
	else:
		velocity.y = 0

	is_in_range_to_attack = true

func _on_attack_range_body_exited(_body):
	is_in_range_to_attack = false
