extends YSort

const ROCK_PATH: PackedScene = preload("res://Resources/Rocks/Rock.tscn")

onready var map: TileMap = owner.get_node("TileMap")


func _ready() -> void:
	while true:
		yield(get_tree().create_timer(8), "timeout")
		_spawn_tree()


func _spawn_tree() -> void:
	var rock: StaticBody2D = ROCK_PATH.instance()
	var rand_point: Vector2 = Vector2(randi() % int(map.map_size.x), randi() % int(map.map_size.y))
	while not map.is_tile_available(rand_point):
		rand_point =  Vector2(randi() % int(map.map_size.x), randi() % int(map.map_size.y))
		
	rock.position = rand_point * Utils.TILE_SIZE + Vector2(4, 4)
	add_child(rock)
