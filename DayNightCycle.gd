extends CanvasModulate

const DAWN_HOUR: int = 6
const SUNSET_HOUR: int = 21

var daytime: bool = true

export(float) var time_scale: float = 0.06
export(float) var initial_hour: float = 6.0

signal dawn()
signal sunset()

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func _ready() -> void:
	animation_player.play("day_night_cycle", -1, time_scale)
	animation_player.seek(initial_hour, true)
	
	if initial_hour >= DAWN_HOUR and initial_hour < SUNSET_HOUR:
		emit_signal("dawn")
		daytime = true
	elif initial_hour >= SUNSET_HOUR or initial_hour < DAWN_HOUR:
		emit_signal("sunset")
		daytime = false
	
	
func _dawn_reached() -> void:
	emit_signal("dawn")
	daytime = true
	
	
func _sunset_reached() -> void:
	emit_signal("sunset")
	daytime = false
