extends Node2D

func _ready() -> void:
	$scroll_speed.text = str(GlobalData.save["scroll_speed"])

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
		
