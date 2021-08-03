extends Character
class_name Worker

export(String, "Trees", "Rocks") var resource_type: String = ""

var front_of_house: Vector2 = Vector2.ZERO

var current_resource: WorldResource = null

var right_path: Array = []
var left_path: Array = []

onready var resource_container: YSort = get_tree().current_scene.get_node("Resources/" + resource_type)

onready var resource_icon: Sprite = get_node("ResourceIcon")


func _ready() -> void:
	assert(resource_type != "")
	resource_icon.hide()
	
	
func can_create_path() -> bool:
	current_resource = get_nearest_resource()
	right_path = map.find_path(position, current_resource.position + Vector2(Utils.TILE_SIZE, 0))
	left_path = map.find_path(position, current_resource.position + Vector2(-Utils.TILE_SIZE, 0))
	if right_path != [] or left_path != []:
		return true
	return false


func path_to_resource() -> void:
	destination_reached = false
	current_resource.available = false
	path = _get_shortest_path()
	target_point_world = path[1]
	
	
func _get_shortest_path() -> Array:
	if right_path == []:
		return left_path
	elif left_path == []:
		return right_path
	else:
		if len(right_path) < len(left_path):
			return right_path
		else:
			return left_path
	
	
func _on_map_changed() -> void:
	if state_machine.state == state_machine.states.going_to_resource:
		if current_resource != get_nearest_resource():
			current_resource.available = true
		if can_create_path():
			path_to_resource()
		elif state_machine.state == state_machine.states.transporting_resource:
			return_to_house()
	
	
func return_to_house() -> void:
	destination_reached = false
	path = map.find_path(position, front_of_house)


func get_nearest_resource() -> StaticBody2D:
	if resource_container.get_child_count() == 0:
		return null
		
	var nearest_resource: WorldResource = null
	for resource in resource_container.get_children():
		if resource.available and nearest_resource == null:
			nearest_resource = resource
		elif nearest_resource != null:
			if (resource.position - position).length() < (nearest_resource.position - position).length() and resource.available:
				nearest_resource = resource
	return nearest_resource
	
	
func _resource_gathered() -> void:
	current_resource.destroy()
	state_machine.set_state(state_machine.states.transporting_resource)
	resource_icon.show()
	
	
func resource_delivered() -> void:
	resource_icon.hide()
	match resource_type:
		"Trees":
			Resources.log_quantity += 1
		"Rocks":
			Resources.stone_quantity += 1
