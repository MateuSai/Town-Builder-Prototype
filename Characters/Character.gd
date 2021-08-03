extends KinematicBody2D
class_name Character

export(int) var hp: int = 2

var direction: Vector2 = Vector2.ZERO
export(int) var speed: int = 50
export(float) var accerelation: float = 0.1
var velocity: Vector2 = Vector2.ZERO

var path: Array = []
var target_point_world: Vector2 = Vector2.ZERO
var destination_reached: bool = true

onready var map: TileMap = get_tree().current_scene.get_node("TileMap")
onready var day_night_cycle: CanvasModulate = get_tree().current_scene.get_node("DayNightCycle")

onready var state_machine: Node = get_node("FiniteStateMachine")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite")
onready var light: Light2D = get_node("Light2D")


func _ready() -> void:
	var __ = map.connect("obstacles_changed", self, "_on_map_changed")
	__ = day_night_cycle.connect("dawn", self, "_on_dawn")
	__ = day_night_cycle.connect("sunset", self, "_on_sunset")
	if day_night_cycle.daytime:
		_on_dawn()
	else:
		_on_sunset()


func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, direction * speed, accerelation)
	velocity = move_and_slide(velocity)
	
	
func follow_path() -> void:
	var arrived_to_next_point: bool = _move_along_path(target_point_world)
	if arrived_to_next_point and len(path) > 0:
		path.remove(0)
		if len(path) == 0:
			destination_reached = true
			return
		target_point_world = path[0]
		
		
func _move_along_path(world_position: Vector2) -> bool:
	var arrive_distance: int = 4
	direction = (world_position - position).normalized()
	return position.distance_to(world_position) < arrive_distance
	
	
func _on_map_changed() -> void:
	pass
	
	
func _on_dawn() -> void:
	light.enabled = false
	
	
func _on_sunset() -> void:
	light.enabled = true
