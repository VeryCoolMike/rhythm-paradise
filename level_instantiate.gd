extends Node2D

@export var json_file: String
@export var level_name: String

func _ready():
	var game_runner_script = load("res://game_runner.gd")
	var target = get_tree().current_scene

	var json_file_temp = json_file
	var level_name_temp = level_name

	target.set_script(game_runner_script)
	target.set_process(true)
	target.call_deferred("load_game", json_file_temp, level_name_temp)
