extends Button

func _on_pressed() -> void:
    if FileAccess.file_exists("user://savegame.json"):
        var dir = DirAccess.open("user://")
        if dir:
            var err = dir.remove("savegame.json")
            if err == OK:
                GlobalData.save = GlobalData.original_save
                get_tree().change_scene_to_file("res://main_menu.tscn")
            else:
                print(err)
