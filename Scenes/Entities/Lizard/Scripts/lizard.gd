extends CharacterBody2D
class_name Enemy

var direction: Vector2 = Vector2.ZERO
var health: int = 60
var is_invincible: bool = false

@export var max_speed: float = 125.0
@export var acceleration: float = 80.0

@onready var sprite = $AnimatedSprite2D
@onready var anim_tree := $AnimationTree
@onready var raycast := $RayCast2D
@onready var hit_flash = $HitFlash
@onready var life_bar = $LifeBar/LifeBar
@onready var invincible_cd = $InvincibleCD
@onready var invincible_cd_time: float = 0.8
@onready var hurt_sound = $HurtSound
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state = $FiniteStateMachine/EnemyChaseState as EnemyChaseState
@onready var label = $Label


func _ready():
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_wander_state))
	anim_tree.active = true

func _process(_delta):
	update_life_bar()
	
func _physics_process(_delta):
	label.text = str(fsm.state)
	raycast.target_position = get_local_mouse_position()

func take_damage(damage: int):
	health -= damage
	hurt_sound.play()
	if health <= 0:
		Global.player_health += 15
		queue_free()
		return

	is_invincible = true
	invincible_cd.start(invincible_cd_time)
	hit_flash.play("flash")

func update_life_bar():
	life_bar.value = health
	if health == life_bar.max_value:
		life_bar.visible = false
	else:
		life_bar.visible = true
