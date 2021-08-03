extends StaticBody2D
class_name Building

export(String) var building_id: String = ""
var building: Object = null

signal placed(pos, tile_size)

export(int) var hp: int = 5

export(Vector2) var size: Vector2 = Vector2.ZERO

onready var sprite: Sprite = get_node("Sprite")
onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")


func _enter_tree() -> void:
	assert(building_id != "")
	building = Data.buildings.get(building_id)
	size = Vector2(building.size_x, building.size_y)


func _ready() -> void:
	var __ = connect("placed", get_tree().current_scene.get_node("TileMap"), "_on_building_placed")
	sprite.texture = load(building.image)
	var sprite_size: Vector2 = sprite.texture.get_size()
	emit_signal("placed", position + Vector2(-sprite_size.x/2.0, sprite_size.y/2.0 - 1), size)
	
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.set_extents(Vector2(building.size_x * 4, building.size_y * 4))
	collision_shape.position.y = 8 - (building.size_y * 4)
