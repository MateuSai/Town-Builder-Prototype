extends FiniteStateMachine


func _init() -> void:
	_add_state("idle")
	_add_state("move")
	
	
func _state_logic(_delta: float) -> void:
	if parent.direction.x < 0:
		sprite.flip_h = false
	elif parent.direction.x > 0:
		sprite.flip_h = true
		
	if state == states.move:
		parent.follow_path()
		
		
func _get_transition() -> int:
	match state:
		states.idle:
			return -1
		states.move:
			if parent.destination_reached:
				return states.idle
	return -1


func _enter_state(_previous_state: int, new_state: int) -> void:
	if new_state == states.idle:
		parent.direction = Vector2.ZERO
		animation_player.play("idle")
	elif new_state == states.move:
		animation_player.play("walk")
