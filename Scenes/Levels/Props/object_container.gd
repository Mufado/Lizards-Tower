extends StaticBody2D

var hit_counter: int = 20
var potion = preload("res://Scenes/Items/health_potion.tscn")
var drop_chance = 0

@onready var animation = $AnimationPlayer
@onready var hit_sound = $HitSound
@onready var TileMapLevel : TileMap = get_node("%TileMap")


func take_damage(damage: int):
	hit_sound.play()
	if hit_counter > 0:
		hit_counter -= damage 
		animation.play("Hit")
	else:
		if drop_chance > 60:
			var drop = potion.instantiate()
			drop.position = $Marker.global_position
			get_parent().add_child(drop)
		_change_tiles(0)
		animation.play("Explosion")

func _ready():
	randomize()
	drop_chance = randi_range(0,100)
	_change_tiles(1)

func _change_tiles(to_alternative):
	if !TileMapLevel == null:
		var tile_pos : Vector2i = TileMapLevel.local_to_map(global_position)
		var neighborR : Vector2i = TileMapLevel.get_neighbor_cell(tile_pos,TileSet.CELL_NEIGHBOR_RIGHT_SIDE)		
		var neighborL : Vector2i = TileMapLevel.get_neighbor_cell(tile_pos,TileSet.CELL_NEIGHBOR_LEFT_SIDE)		
		var neighborT : Vector2i = TileMapLevel.get_neighbor_cell(tile_pos,TileSet.CELL_NEIGHBOR_TOP_SIDE)	
		var neighborTL : Vector2i = TileMapLevel.get_neighbor_cell(neighborT,TileSet.CELL_NEIGHBOR_LEFT_SIDE)	
		var neighborTR : Vector2i = TileMapLevel.get_neighbor_cell(neighborT,TileSet.CELL_NEIGHBOR_RIGHT_SIDE)	
		var neighborT1 : Vector2i = TileMapLevel.get_neighbor_cell(neighborT,TileSet.CELL_NEIGHBOR_TOP_SIDE)	
		var neighborTL1 : Vector2i = TileMapLevel.get_neighbor_cell(neighborT1,TileSet.CELL_NEIGHBOR_LEFT_SIDE)	
		var neighborTR1 : Vector2i = TileMapLevel.get_neighbor_cell(neighborT1,TileSet.CELL_NEIGHBOR_RIGHT_SIDE)	

		_change_tile_to_alternate(tile_pos,to_alternative)
		_change_tile_to_alternate(neighborR,to_alternative)
		_change_tile_to_alternate(neighborL,to_alternative)
		_change_tile_to_alternate(neighborT,to_alternative)
		_change_tile_to_alternate(neighborTL,to_alternative)
		_change_tile_to_alternate(neighborTR,to_alternative)
		_change_tile_to_alternate(neighborT1,to_alternative)
		_change_tile_to_alternate(neighborTL1,to_alternative)
		_change_tile_to_alternate(neighborTR1,to_alternative)

func _change_tile_to_alternate(tile_position : Vector2i,to_alternative):
	var source = TileMapLevel.get_cell_source_id(1, tile_position)
	var atlas = TileMapLevel.get_cell_atlas_coords(1, tile_position)
	var _alternative = TileMapLevel.get_cell_source_id(1, tile_position)

	TileMapLevel.erase_cell(1, tile_position)

	TileMapLevel.set_cell(1, tile_position, source,atlas, to_alternative)
