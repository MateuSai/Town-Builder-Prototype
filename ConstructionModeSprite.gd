extends Sprite

var building_id: String = ""
var building: Object = null

var sprite_size: Vector2 = Vector2.ZERO
var sprite_tile_size: Vector2 = Vector2.ZERO
var x_offset: int = 0

var can_be_placed: bool = false

onready var map: TileMap = get_tree().current_scene.get_node("TileMap")


func _enter_tree() -> void:
	assert(building_id != "")
	building = Data.buildings.get(building_id)
	texture = load(building.image)
	sprite_size = texture.get_size()
	sprite_tile_size = Vector2(building.size_x, building.size_y)
	x_offset = (building.size_x % 2) * 4


func _process(_delta: float) -> void:
	var tile_pos: Vector2 = map.world_to_map(get_global_mouse_position())
	position = tile_pos * Utils.TILE_SIZE + Vector2(x_offset, 0)
	
	can_be_placed = _update_can_be_placed(position + Vector2(-sprite_size.x/2.0, sprite_size.y/2.0 - 1))
	
	if can_be_placed:
		modulate = Color(0, 1, 0, 0.75)
	else:
		modulate = Color(1, 0, 0, 0.75)
	
	
func _update_can_be_placed(corner_pos: Vector2) -> bool:
	for x in sprite_tile_size.x:
		if not map.is_tile_available(map.world_to_map(corner_pos) + Vector2(x, 1)):
			return false
		for y in sprite_tile_size.y:
			if not map.is_tile_available(map.world_to_map(corner_pos) + Vector2(x, -y)):
				return false
	return true
