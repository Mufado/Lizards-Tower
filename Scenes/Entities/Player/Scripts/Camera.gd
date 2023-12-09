extends Camera2D
signal camerashake

@export var randomStrength: float = 2.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var camera_shake = false

func apply_shake():
	shake_strength = randomStrength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),0)
	
func _process(delta):
	if camera_shake:
		camera_shake = false
		apply_shake()
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0, shakeFade * delta)
		
		offset = randomOffset()


func _on_camerashake():
	camera_shake = true
