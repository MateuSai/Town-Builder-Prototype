extends Control

var construction_mode_activated: bool = false


func _gui_input(event: InputEvent) -> void:
	if construction_mode_activated:
		if event.is_action_pressed("ui_click"):
			if _can_spawn_new_building():
				_spawn_new_building()
			_exit_construction_mode()
		elif event.is_action_pressed("ui_right_click"):
			_exit_construction_mode()


func _on_Player_right_click() -> void:
	if not construction_mode_activated:
		_enter_construction_mode()
	
	
func _enter_construction_mode() -> void:
	construction_mode_activated = true
	
	var construction_sprite: Sprite = Sprite.new()
	construction_sprite.set_script(preload("res://ConstructionModeSprite.gd"))
	construction_sprite.building_id = Data.buildings.lumberjack_house
	add_child(construction_sprite)
	
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _exit_construction_mode() -> void:
	construction_mode_activated = false
	
	get_child(0).queue_free()
	
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func _can_spawn_new_building() -> bool:
	if get_child(0) != null:
		if get_child(0).can_be_placed:
			return true
	return false
	
	
func _spawn_new_building() -> void:
	var buildind_data: Object = get_child(0).building
	var new_building: Building = load(buildind_data.scene).instance()
	new_building.building_id = buildind_data.id
	new_building.position = get_child(0).position
	owner.add_child(new_building)
	Resources.log_quantity -= 2
