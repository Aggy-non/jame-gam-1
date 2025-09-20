extends Node2D

@export var lane_id := 0  # Set this to 0, 1, 2, or 3 per lane instance
@export var note_scene: PackedScene
@export var min_scale := 0.5
@export var max_scale := 2.0

class ScalerNode:
	extends Node

	var follower: PathFollow2D
	var note: Node2D
	var min_scale := 0.5
	var max_scale := 2.0

	func _process(delta):
		var t: float = follower.progress_ratio
		var s: float = lerp(min_scale, max_scale, t)
		note.scale = Vector2(s, s)
		if t >= 1.0:
			queue_free()

func _ready():
	var beat_manager := get_node("/root/Main/BeatManager")  # Adjust path if needed
	beat_manager.connect("beat", Callable(self, "_on_beat"))

func _on_beat(lane: int, time: float):
	if lane == lane_id:
		spawn_note()

func spawn_note():
	var follower := PathFollow2D.new()
	follower.rotates = false
	$Path2D.add_child(follower)

	var note := note_scene.instantiate()
	follower.add_child(note)

	follower.progress_ratio = 0.0

	var scaler := ScalerNode.new()
	scaler.follower = follower
	scaler.note = note
	scaler.min_scale = min_scale
	scaler.max_scale = max_scale
	add_child(scaler)

	var tween := get_tree().create_tween()
	tween.tween_property(follower, "progress_ratio", 1.0, 2.0)
