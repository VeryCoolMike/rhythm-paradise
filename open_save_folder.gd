extends Button

func _on_pressed() -> void:
    OS.shell_open(OS.get_user_data_dir())