extends StaticBody2D
class_name WorldResource

signal resource_destroyed(pos)

var available: bool = true

onready var map: TileMap = get_tree().current_scene.get_node("TileMap")


func _ready() -> void:
	map.add_obstacles([map.world_to_map(position)])
	var __ = connect("resource_destroyed", map, "_on_resource_destroyed")


func destroy() -> void:
	emit_signal("resource_destroyed", position)
	queue_free()
