extends CharacterBody2D
class_name Lizard

const SPEED = 100.0

var direction: Vector2 = Vector2.ZERO
var is_in_range_to_attack: bool = false

@export var nav_agent_target: Node2D
@onready var nav_agent := $NavigationAgent2D
@onready var anim_tree := $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")


func _physics_process(_delta):
	nav_agent.set_target_position(nav_agent_target.global_position)
	
	direction = (nav_agent.get_next_path_position() - global_position).normalized()
	
	if is_in_range_to_attack:
		direction = _get_attack_direction();
		
		if abs(direction.x) <= 0.1 || abs(direction.y) <= 0.1:
			state_machine.travel("Attack")
			anim_tree.set("parameters/Attack/blend_position", direction)
			velocity = Vector2.ZERO
	elif state_machine.get_current_node() == "Attack":
		state_machine.travel("ChasePlayer")
	else:
		anim_tree.set("parameters/ChasePlayer/blend_position", direction)
		velocity = direction * SPEED

	move_and_slide()

func _get_attack_direction():
	return (nav_agent_target.global_position - global_position).normalized()

func _on_attack_range_body_entered(_body):
	if abs(velocity.x) < abs(velocity.y):
		velocity.x = 0
	else:
		velocity.y = 0

	is_in_range_to_attack = true

func _on_attack_range_body_exited(_body):
	is_in_range_to_attack = false
