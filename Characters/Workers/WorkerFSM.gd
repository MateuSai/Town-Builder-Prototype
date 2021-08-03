extends FiniteStateMachine


func _init() -> void:
	_add_state("idle")
	_add_state("going_to_resource")
	_add_state("gathering_resource")
	_add_state("transporting_resource")


func _state_logic(_delta: float) -> void:
	if parent.direction.x < 0:
		sprite.flip_h = false
	elif parent.direction.x > 0:
		sprite.flip_h = true
		
	if state == states.going_to_resource or state == states.transporting_resource:
		parent.follow_path()
	
	
func _get_transition() -> int:
	match state:
		states.idle:
			if (parent.resource_container.get_child_count() > 0 and parent.get_nearest_resource() != null and
				parent.can_create_path()):
				return states.going_to_resource
				
		states.going_to_resource:
			if parent.destination_reached:
				return states.gathering_resource
				
		states.gathering_resource:
			pass
			
		states.transporting_resource:
			if parent.destination_reached:
				return states.idle
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	if new_state == states.idle:
		parent.direction = Vector2.ZERO
		animation_player.play("idle")
	elif new_state == states.going_to_resource:
		animation_player.play("walk")
		parent.path_to_resource()
	elif new_state == states.gathering_resource:
		parent.direction = Vector2.ZERO
		animation_player.play("gather_resource")
	elif new_state == states.transporting_resource:
		animation_player.play("walk")
		parent.return_to_house()
	
	
func _exit_state(state_exited: int) -> void:
	if state_exited == states.transporting_resource:
		parent.resource_delivered()
