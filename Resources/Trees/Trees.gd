extends Node2D

const TREE_PATH: PackedScene = preload("res://Resources/Trees/NormalTree.tscn")

onready var map: TileMap = owner.get_node("TileMap")


func _ready() -> void:
	while true:
		yield(get_tree().create_timer(3), "timeout")
		_spawn_tree()


func _spawn_tree() -> void:
	var tree: StaticBody2D = TREE_PATH.instance()
	var rand_point: Vector2 = Vector2(randi() % int(map.map_size.x), randi() % int(map.map_size.y))
	while not map.is_tile_available(rand_point):
		rand_point =  Vector2(randi() % int(map.map_size.x), randi() % int(map.map_size.y))
		
	tree.position = rand_point * Utils.TILE_SIZE + Vector2(4, 4)
	add_child(tree)
