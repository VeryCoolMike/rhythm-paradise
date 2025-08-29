extends Node2D

# Konami code sequence (using Godot's Input keys)
var konami_code = [
	KEY_UP, KEY_UP,
	KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT,
	KEY_LEFT, KEY_RIGHT,
	KEY_B, KEY_A
]

var current_index = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == konami_code[current_index]:
			current_index += 1
			if current_index == konami_code.size():
				_on_konami_code()
				current_index = 0
		else:
			current_index = 0

func _on_konami_code() -> void:
	print("Secret activated!")
	get_tree().change_scene_to_file("res://levels/secret_level/secret_level.tscn")

func _ready() -> void:
	if not FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(GlobalData.save))
			file.close()
	var file = FileAccess.open("user://savegame.json", FileAccess.READ);
	var contents = file.get_as_text()
	file.close()
	GlobalData.save = JSON.parse_string(contents)
