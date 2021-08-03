extends Character

signal right_click()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click"):
		path = map.find_path(position, get_global_mouse_position())
		if path != []:
			destination_reached = false
			state_machine.set_state(state_machine.states.move)
			target_point_world = path[1]
			
	if event.is_action_pressed("ui_right_click"):
		emit_signal("right_click")
