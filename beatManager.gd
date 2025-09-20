extends Node

signal beat(lane: int, time: float)

@export var beatmap: Array = [
	{"time": 0.5, "lane": 0},
	{"time": 1.0, "lane": 1},
	{"time": 1.5, "lane": 2},
	{"time": 2.0, "lane": 3},
]
func _ready():
	for beat in beatmap:
		spawn_beat_later(beat)

func spawn_beat_later(beat_data: Dictionary):
	await get_tree().create_timer(beat_data["time"]).timeout
	emit_signal("beat", beat_data["lane"], beat_data["time"])
