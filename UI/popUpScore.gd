extends Label

onready var tween: Tween = get_node("Tween")


func start(size: Vector2, pos: Vector2, direction: int, distance: int = 12, label_text: String = "+1") -> void:
	rect_size = size
	text = label_text
	
	tween.interpolate_property(self, "rect_position", pos, Vector2(pos.x, pos.y + distance * direction), 0.3,
								Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
	tween.start()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
