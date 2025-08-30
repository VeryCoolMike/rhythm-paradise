extends Node2D

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
