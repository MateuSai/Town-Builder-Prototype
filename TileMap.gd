extends TileMap

export(Vector2) var map_size: Vector2 = get_used_rect().size

var obstacles: Array = [] setget _set_obstacles
signal obstacles_changed()
var unavailable_tiles: Array = []

var tile_offset: Vector2 = Vector2(Utils.TILE_SIZE/2.0, Utils.TILE_SIZE/2.0)

onready var tree_container: Node2D = get_parent().get_node("Resources/Trees")
onready var astar_node: AStar2D = AStar2D.new()


func _ready():
	_update_astar_node()
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(world_to_map(get_global_mouse_position()))
	
	
func _update_astar_node() -> void:
	astar_node.clear()
	var walkable_cells_list: Array = astar_add_walkable_cells()
	astar_connect_walkable_cells_diagonal(walkable_cells_list)
	
	
func astar_add_walkable_cells() -> Array:
	var points_array: Array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point: Vector2 = Vector2(x, y)
			if point in obstacles:
				continue
				
			points_array.append(point)
			var point_index: int = calculate_point_index(point)
			astar_node.add_point(point_index, point)
	return points_array
			
			
# Connects cells horizontally, vertically AND diagonally
func astar_connect_walkable_cells_diagonal(points_array: Array) -> void:
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)
				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				if local_x - 1 != 0 and local_y - 1 != 0:
					if (point + Vector2(local_x - 1, 0) in obstacles) and (point + Vector2(0, local_y - 1) in obstacles):
						continue
				astar_node.connect_points(point_index, point_relative_index, false)
			
			
func is_outside_map_bounds(point: Vector2) -> bool:
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y
			
			
func calculate_point_index(point: Vector2):
	return point.x + map_size.x * point.y
	
	
func is_path_valid(start_point: Vector2, end_point: Vector2) -> bool:
	if start_point in obstacles or end_point in obstacles:
		return false
	if is_outside_map_bounds(start_point) or is_outside_map_bounds(end_point):
		return false
	if start_point == end_point:
		return false
	return true
	
	
func find_path(world_start: Vector2, world_end: Vector2) -> Array:
	var path_start_position: Vector2 = world_to_map(world_start)
	var path_end_position: Vector2 = world_to_map(world_end)
	var path_world: Array = []
	if is_path_valid(path_start_position, path_end_position):
		var point_path: Array = _calculate_path(path_start_position, path_end_position)
		for point in point_path:
			var point_world: Vector2 = map_to_world(point) + tile_offset
			path_world.append(point_world)
	return path_world
	
	
func is_tile_available(tile_pos: Vector2) -> bool:
	if tile_pos in obstacles or tile_pos in unavailable_tiles:
		return false
	return true
	
	
func _calculate_path(start_point: Vector2, end_point: Vector2) -> PoolVector2Array:
	var start_point_index = calculate_point_index(start_point)
	var end_point_index = calculate_point_index(end_point)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	return astar_node.get_point_path(start_point_index, end_point_index)
		
		
func _on_building_placed(pos: Vector2, building_size_in_tiles: Vector2) -> void:
	var map_position: Vector2 = world_to_map(pos)
	var new_obstacles: Array = []
	for x in building_size_in_tiles.x:
		var under_point: Vector2 = Vector2(map_position.x + x, map_position.y + 1)
		var under_point_index: int = calculate_point_index(under_point)
		if not under_point in obstacles and not under_point in unavailable_tiles and not is_outside_map_bounds(under_point):
			if astar_node.has_point(under_point_index):
				unavailable_tiles.append(under_point)
			
		for y in building_size_in_tiles.y:
			new_obstacles.append(Vector2(map_position) + Vector2(x, -y))
	add_obstacles(new_obstacles)
	
	
func _on_resource_destroyed(world_pos: Vector2) -> void:
	var obstacle: Vector2 = world_to_map(world_pos)
	delete_obstacles([obstacle])
	
	
func add_obstacles(new_obstacles: Array) -> void:
	var updated_obstacles: Array = obstacles
	for obstacle in new_obstacles:
		updated_obstacles.append(obstacle)
	self.obstacles = updated_obstacles
	
	
func delete_obstacles(new_obstacles: Array) -> void:
	var updated_obstacles: Array = obstacles
	for obstacle in new_obstacles:
		updated_obstacles.erase(obstacle)
	self.obstacles = updated_obstacles
		
		
func _set_obstacles(new_obstacles: Array) -> void:
	obstacles = new_obstacles
	_update_astar_node()
	emit_signal("obstacles_changed")
