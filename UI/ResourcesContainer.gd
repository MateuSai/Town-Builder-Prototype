extends VBoxContainer

const POP_UP_SCORE_SCENE: PackedScene = preload("res://UI/popUpScore.tscn")

onready var log_container_label: Label = get_node("LogContainer/Label")
onready var stone_container_label: Label = get_node("StoneContainer/Label")


func _ready() -> void:
	var __ = Resources.connect("update_resource_UI", self, "_on_Resources_update")


func _on_Resources_update(resource: int, quantity: int) -> void:
	match resource:
		Resources.LOG:
			if int(log_container_label.text) < quantity:
				_spawn_pop_up_score(log_container_label, Vector2(0, 12), -1)
			else:
				_spawn_pop_up_score(log_container_label, Vector2.ZERO, 1, 12, "-2")
			log_container_label.text = str(quantity)
		Resources.STONE:
			stone_container_label.text = str(quantity)
			
			
func _spawn_pop_up_score(resource_container_label: Label, offset: Vector2, direction: int, distance: int = 12,
						text: String = "+1") -> void:
	var pop_up_score: Label = POP_UP_SCORE_SCENE.instance()
	get_parent().add_child(pop_up_score)
	pop_up_score.start(resource_container_label.rect_size, resource_container_label.rect_global_position + offset,
						direction, distance, text)
