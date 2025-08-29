extends Node2D

var current_layer = 1

func secret_unlocked_check(layer) -> bool:
	if layer == 1:
		if GlobalData.save["rank_1_1"] == 0 and GlobalData.save["rank_1_2"] == 0 and GlobalData.save["rank_1_3"] == 0:
			return true
		else:
			return false
	elif layer == 2:
		if GlobalData.save["rank_2_1"] == 0 and GlobalData.save["rank_2_2"] == 0 and GlobalData.save["rank_2_3"] == 0:
			return true
		else:
			return false
	elif layer == 3:
		if GlobalData.save["rank_3_1"] == 0 and GlobalData.save["rank_3_2"] == 0 and GlobalData.save["rank_3_3"] == 0:
			return true
		else:
			return false
	else:
		return false

func refresh_visible() -> void:
	if current_layer == 1:
		$ColorRect/layer_1.visible = true
		$ColorRect/layer_2.visible = false
		$ColorRect/layer_3.visible = false
	elif current_layer == 2:
		$ColorRect/layer_1.visible = false
		$ColorRect/layer_2.visible = true
		$ColorRect/layer_3.visible = false
	elif current_layer == 3:
		$ColorRect/layer_1.visible = false
		$ColorRect/layer_2.visible = false
		$ColorRect/layer_3.visible = true

func accuracy_to_rank(accuracy: int) -> String:
	match accuracy:
		0:
			return "[P]"
		1:
			return "[S]"
		2:
			return "[A]"
		3:
			return "[B]"
		4:
			return "[C]"
		5:
			return "[D]"
		_:
			return "[-]"

func _ready() -> void:
	if secret_unlocked_check(1):
		GlobalData.save["unlocked_1"] = true
	if secret_unlocked_check(2):
		GlobalData.save["unlocked_2"] = true
	if secret_unlocked_check(3):
		GlobalData.save["unlocked_3"] = true
	
	$ColorRect/layer_1/level_1.text = "LEVEL 1 " + accuracy_to_rank(GlobalData.save["rank_1_1"])
	$ColorRect/layer_1/level_2.text = "LEVEL 2 " + accuracy_to_rank(GlobalData.save["rank_1_2"])
	$ColorRect/layer_1/level_3.text = "LEVEL 3 " + accuracy_to_rank(GlobalData.save["rank_1_3"])
	$ColorRect/layer_1/level_4.text = "SECRET LEVEL " + accuracy_to_rank(GlobalData.save["rank_1_4"])

	$ColorRect/layer_2/level_1.text = "LEVEL 1 " + accuracy_to_rank(GlobalData.save["rank_2_1"])
	$ColorRect/layer_2/level_2.text = "LEVEL 2 " + accuracy_to_rank(GlobalData.save["rank_2_2"])
	$ColorRect/layer_2/level_3.text = "LEVEL 3 " + accuracy_to_rank(GlobalData.save["rank_2_3"])
	$ColorRect/layer_2/level_4.text = "SECRET LEVEL " + accuracy_to_rank(GlobalData.save["rank_2_4"])

	$ColorRect/layer_3/level_1.text = "LEVEL 1 " + accuracy_to_rank(GlobalData.save["rank_3_1"])
	$ColorRect/layer_3/level_2.text = "LEVEL 2 " + accuracy_to_rank(GlobalData.save["rank_3_2"])
	#$ColorRect/layer_3/level_3.text = "LEVEL 3 " + accuracy_to_rank(GlobalData.rank_3_3)
	#$ColorRect/layer_3/level_4.text = "SECRET LEVEL " + accuracy_to_rank(GlobalData.rank_3_4)


func _on_forward_pressed() -> void:
	if current_layer < 3: # The amount of layers
		current_layer += 1
		refresh_visible()

func _on_back_pressed() -> void:
	if current_layer > 1:
		current_layer -= 1
		refresh_visible()

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
