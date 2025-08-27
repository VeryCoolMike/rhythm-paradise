extends Button



func _on_pressed() -> void:
	if GlobalData.secret_level_unlocked == true:
		get_tree().change_scene_to_file("res://levels/secret_level/secret_level.tscn") # Replace with function body.
