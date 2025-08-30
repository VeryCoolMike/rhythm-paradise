extends Node2D

var konami_code = [
	KEY_UP, KEY_UP,
	KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT,
	KEY_LEFT, KEY_RIGHT,
	KEY_B, KEY_A
]

var current_index = 0
var waiting_for_number = false  # Flag to indicate next key should be a number

var secret_code = [
	KEY_L, KEY_O, KEY_L
]

var current_index_2 = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if waiting_for_number:
			var num = _key_to_number(event.keycode)
			if num != null:
				_on_konami_code(num)
			waiting_for_number = false
			return

		# Regular Konami code detection
		if event.keycode == konami_code[current_index]:
			current_index += 1
			if current_index == konami_code.size():
				waiting_for_number = true  # Next key will be the number
				current_index = 0
		else:
			current_index = 0
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == secret_code[current_index_2]:
			current_index_2 += 1
			if current_index_2 == secret_code.size():
				_on_secret_code()
				current_index_2 = 0
		else:
			current_index_2 = 0

# Convert keycode to number (0-9) if possible
func _key_to_number(keycode: int) -> int:
	match keycode:
		KEY_0: return 0
		KEY_1: return 1
		KEY_2: return 2
		KEY_3: return 3
		KEY_4: return 4
		KEY_5: return 5
		KEY_6: return 6
		KEY_7: return 7
		KEY_8: return 8
		KEY_9: return 9
		_: return 0

func _on_konami_code(num: int) -> void:
	print("Secret activated with number:", num)
	if num == 1:
		get_tree().change_scene_to_file("res://levels/secret_level/secret_level.tscn")
	elif num == 2:
		get_tree().change_scene_to_file("res://levels/secret_level_2/secret_level.tscn")

func _on_secret_code() -> void:
	print("Secret activated!")
	GlobalData.cheat = true



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
