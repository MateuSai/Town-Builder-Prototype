extends Building
class_name DeployBuilding

var unit_scene: PackedScene = null
export(int) var max_num_units: int = 1

onready var unit_container: Node2D = get_tree().current_scene.get_node("Characters/Workers")

onready var front: Position2D = get_node("Front")


func _ready() -> void:
	assert(unit_container != null)
	unit_scene = load(building.unit)
	yield(get_tree().create_timer(1), "timeout")
	for i in max_num_units:
		_spawn_unit()
	
	
func _spawn_unit() -> void:
	var unit: Character = unit_scene.instance()
	unit.position = position + Vector2(0, 16)
	unit.front_of_house = front.global_position
	unit_container.add_child(unit)
