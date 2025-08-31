extends Node2D

func _ready() -> void:
	$scroll_speed.text = str(int(GlobalData.save["scroll_speed"]))
	if OS.has_feature("web"):
		$Button4.visible = false
		$Button5.visible = false

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
		
func on_level_file_loaded(bytes_array: Array) -> void:
	var zip_data = PackedByteArray()
	for b in bytes_array:
		zip_data.append(b)

	print("Zip size:", zip_data.size())

    # Save to user://
	var f = FileAccess.open("user://level.zip", FileAccess.WRITE)
	f.store_buffer(zip_data)
	f.close()
