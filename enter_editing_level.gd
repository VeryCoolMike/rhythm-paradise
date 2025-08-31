extends Button

func _on_pressed() -> void:
	$FileDialog.popup()


func _on_file_selected(path: String) -> void:
	GlobalData.level_editing = true

	var file = FileAccess.open(path, FileAccess.READ)

	var dir = DirAccess.open("user://")
	if not dir.dir_exists("NEW-LEVEL"):
		dir.make_dir("NEW-LEVEL")
	var copy = FileAccess.open("user://NEW-LEVEL/level.wav", FileAccess.WRITE)

	var wav_bytes = file.get_buffer(file.get_length())
	copy.store_buffer(wav_bytes)
	var audio_stream = AudioStreamWAV.load_from_buffer(wav_bytes)
	if audio_stream:
		GlobalData.latest_song = audio_stream

	var scene_resource = load("res://levels/temp_level/level.tscn")
	get_tree().call_deferred("change_scene_to_packed", scene_resource)
