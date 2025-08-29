extends Node2D

var secret_code = [
	KEY_L, KEY_O, KEY_L
]

var current_index = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == secret_code[current_index]:
			current_index += 1
			if current_index == secret_code.size():
				_on_secret_code()
				current_index = 0
		else:
			current_index = 0

func _on_secret_code() -> void:
	print("Secret activated!")
	GlobalData.save["rank_1_1"] = 0
	GlobalData.save["rank_1_2"] = 0
	GlobalData.save["rank_1_3"] = 0
	GlobalData.save["rank_1_4"] = 0
	GlobalData.save["unlocked_1"] = true

	GlobalData.save["rank_2_1"] = 0
	GlobalData.save["rank_2_2"] = 0
	GlobalData.save["rank_2_3"] = 0
	GlobalData.save["rank_2_4"] = 0
	GlobalData.save["unlocked_2"] = true

	GlobalData.save["rank_3_1"] = 0
	GlobalData.save["rank_3_2"] = 0
	GlobalData.save["rank_3_3"] = 0
	GlobalData.save["rank_3_4"] = 0
	GlobalData.save["unlocked_3"] = true

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(GlobalData.save))
		file.close()

func accuracy_to_rank(accuracy: int) -> String:
	match accuracy:
		0:
			return "P"
		1:
			return "S"
		2:
			return "A"
		3:
			return "B"
		4:
			return "C"
		5:
			return "D"
		_:
			return "-"

func _ready() -> void:
	$ColorRect/rank.text = accuracy_to_rank(GlobalData.latest_rank)
	$ColorRect/accuracy.text = str(snapped(GlobalData.latest_accuracy, 0.01)) + "%\nAccuracy"
