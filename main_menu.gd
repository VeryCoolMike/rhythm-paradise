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