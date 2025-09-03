extends Button

func _on_pressed() -> void:
	GlobalData.save["scroll_speed"] = int(get_node("../scroll_speed").text)
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(GlobalData.save))
		file.close()
	get_tree().change_scene_to_file("res://main_menu.tscn")
