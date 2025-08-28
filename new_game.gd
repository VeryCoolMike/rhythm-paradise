extends Button

@export var scene: PackedScene
@export var secret_level: String = ""

func _on_pressed() -> void:
	if secret_level == "1" and GlobalData.unlocked_1 == false:
		return
	if secret_level == "2" and GlobalData.unlocked_2 == false:
		return
	get_tree().change_scene_to_packed(scene)
