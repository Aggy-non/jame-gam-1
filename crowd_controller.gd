extends Node2D

signal crowd_state_changed(new_state)

var current_state = "idle"

func set_state(new_state: String):
	current_state = new_state
	emit_signal("crowd_state_changed", new_state)
