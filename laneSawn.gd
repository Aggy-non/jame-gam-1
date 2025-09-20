extends Node2D

@export var note_scene: PackedScene
@export var spawn_rate := 1.0
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
	spawn_loop()

func spawn_loop():
	while true:
		spawn_note()
		await get_tree().create_timer(spawn_rate).timeout

func spawn_note():
	var follower := PathFollow2D.new()
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
