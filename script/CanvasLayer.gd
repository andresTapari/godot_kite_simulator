extends CanvasLayer

func _input(event) -> void:
	if event is InputEventKey and event.scancode == KEY_T:
#		get_tree().paused = false
		get_tree().reload_current_scene()

