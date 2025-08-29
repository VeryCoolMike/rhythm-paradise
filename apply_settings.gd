extends Button

func _on_pressed() -> void:
	GlobalData.save["scroll_speed"] = int(get_node("../scroll_speed").text)
	get_tree().change_scene_to_file("res://main_menu.tscn")
