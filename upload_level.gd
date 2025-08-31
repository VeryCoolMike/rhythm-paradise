extends Button

func _on_pressed():
	$FileDialog.popup()

func _on_file_selected(path):
	print(path)
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		print("no good")
	print(len(reader.get_files()))
	var level_file
	var song_file
	for v in reader.get_files():
		if v.ends_with("level.json"):
			level_file = v
		elif v.ends_with("level.wav"):
			song_file = v

	var json_file = reader.read_file(level_file)
	var json_text = json_file.get_string_from_utf8()
	GlobalData.latest_json_raw = json_text

	var wav_bytes = reader.read_file(song_file)
	var audio_stream = AudioStreamWAV.load_from_buffer(wav_bytes)
	if audio_stream:
		GlobalData.latest_song = audio_stream


	var scene_resource = load("res://levels/temp_level/level.tscn")

	get_tree().call_deferred("change_scene_to_packed", scene_resource)
	reader.close()
