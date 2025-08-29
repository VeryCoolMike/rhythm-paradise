extends Button

@export var scene: PackedScene
@export var secret_level: String = ""

func _on_pressed() -> void:
	if secret_level == "1" and GlobalData.save["unlocked_1"] == false:
		return
	if secret_level == "2" and GlobalData.save["unlocked_2"] == false:
		return
	if secret_level == "3" and GlobalData.save["unlocked_3"] == false:
		return
	get_tree().change_scene_to_packed(scene)
