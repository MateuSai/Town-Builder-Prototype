extends Node

enum {LOG, STONE}
var log_quantity: int = 0 setget _set_log_quantity
var stone_quantity: int = 0 setget _set_stone_quantity

signal update_resource_UI(resource, quantity)


func _set_log_quantity(new_quantity: int) -> void:
	log_quantity = new_quantity
	emit_signal("update_resource_UI", LOG, log_quantity)
	
	
func _set_stone_quantity(new_quantity: int) -> void:
	stone_quantity = new_quantity
	emit_signal("update_resource_UI", STONE, stone_quantity)
