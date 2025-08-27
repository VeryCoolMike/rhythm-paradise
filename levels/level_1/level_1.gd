extends Node2D

func _ready():
	var game_runner_script = load("res://game_runner.gd")
	var target = get_tree().current_scene

	target.set_script(game_runner_script)
	target.set_process(true)
	target.call_deferred("load_game", "res://levels/level_1/level_1.json", "level_1")
