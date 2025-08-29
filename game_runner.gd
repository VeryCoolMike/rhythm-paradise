extends Node2D

var bpm = 71.0;
var song_start_time = 0.0;
var song_end_time = 999; # 101.03
var song_ended = false;
var song_name = "YOU ARE IN LEVEL EDITING MODE!"
var scroll_speed = 800
var current_level = ""

var json_file: String = ""
var level_name: String = "empty"

var level_editing = false

var note_scene = load("res://note.tscn")
var lane_1_style = load("res://lane_1.tres")
var lane_2_style = load("res://lane_2.tres")
var lane_3_style = load("res://lane_3.tres")
var lane_4_style = load("res://lane_4.tres")

var scores = {
	Accuracy.SUPER: 0,
	Accuracy.GREAT: 0,
	Accuracy.GOOD: 0,
	Accuracy.MEH: 0,
	Accuracy.BAD: 0,
	Accuracy.MISS: 0
}

var notes = [
	#{"time": 3.0, "lane": 1} // Deprecated, use create_note() function now
];

var active_holds = []; 
# Array with indexes to notes that are in the notes array (just do notes[active_holds[0]] to get the first active hold note)

var editing_holds = {};

var note_instances = [];

enum Accuracy {
	SUPER, # <= 100ms
	GREAT, # <= 200ms
	GOOD, # <= 300ms
	MEH, # <= 400ms
	BAD, # <= 500ms
	MISS # > 600ms
}

enum AccuracyRank {
	P, # >= 99.0
	S, # >= 96.0
	A, # >= 90.0
	B, # >= 80.0
	C, # >= 75.0
	D, # < 75.0
}

func load_game(level, level_string = "empty"):
	print(level)
	print(level_string)
	song_start_time = get_time();

	current_level = level_string
	scroll_speed = GlobalData.save["scroll_speed"]

	if level_editing == false:
		var file := FileAccess.open(level, FileAccess.READ)
		if file:
			var json_text: String = file.get_as_text()
			file.close()

			var parsed_data: Variant = JSON.parse_string(json_text)
			if typeof(parsed_data) == TYPE_DICTIONARY:
				var data: Dictionary = parsed_data
				song_name = data["song_name"]
				song_end_time = data["song_end_time"]

				for note in data["notes"]:
					var note_time = note["time"]
					var note_lane = note["lane"]
					var note_is_hold = note["is_hold"]
					var note_hold_length = note["hold_length"]

					create_note(note_time, note_lane, note_is_hold, note_hold_length)
		


func get_time():
	return Time.get_ticks_msec() / 1000.0;
	
func get_real_time():
	return get_time() - song_start_time;
	
func get_closest_number(array: Array, target: float, lane: int) -> int:
	var closest_index = -1
	var smallest_difference = INF
	
	for index in range(array.size()):
		var note = array[index]
		if note.lane != lane:
			continue
		var element = array[index].time
		if abs(target - element) < smallest_difference:
			if array[index].is_hold == true and element - get_real_time() > 0.2:
				continue
			closest_index = index
			smallest_difference = abs(target - element)
	
	return closest_index

func create_note(time: float, lane: int, is_hold: bool = false, hold_length: float = 0.0):
	var note = {
		"time": time,
		"lane": lane,
		"is_hold": is_hold,
		"hold_length": hold_length,
		"being_held": false,
		"dead": false
	}
	notes.append(note)

	var note_instance = note_scene.instantiate()
	if note["is_hold"] == true:
		note_instance.get_node("Hold_Bar").size.y = note.hold_length * scroll_speed
		#note_instance.get_node("Panel").visible = false
	if note["lane"] == 1:
		note_instance.position.x = 415 + 40
		note_instance.get_node("Panel").add_theme_stylebox_override("panel", lane_1_style)
		note_instance.get_node("Hold_Bar").add_theme_stylebox_override("panel", lane_1_style)
	if note["lane"] == 2:
		note_instance.position.x = 415 + 120
		note_instance.get_node("Panel").add_theme_stylebox_override("panel", lane_2_style)
		note_instance.get_node("Hold_Bar").add_theme_stylebox_override("panel", lane_2_style)
	if note["lane"] == 3:
		note_instance.position.x = 415 + 200
		note_instance.get_node("Panel").add_theme_stylebox_override("panel", lane_3_style)
		note_instance.get_node("Hold_Bar").add_theme_stylebox_override("panel", lane_3_style)
	if note["lane"] == 4:
		note_instance.position.x = 415 + 280
		note_instance.get_node("Panel").add_theme_stylebox_override("panel", lane_4_style)
		note_instance.get_node("Hold_Bar").add_theme_stylebox_override("panel", lane_4_style)

	note_instance.position.y = -100
	note_instances.append(note_instance)
	add_child(note_instance)
			
func get_accuracy(lane: int) -> Accuracy:
	var time = get_real_time()
	var closest_number = get_closest_number(notes, time, lane)
	if closest_number == -1:
		return Accuracy.MISS
	var difference = abs(notes[closest_number].time - time)
	
	if difference <= 0.1:
		return Accuracy.SUPER
	elif difference <= 0.2:
		return Accuracy.GREAT
	elif difference <= 0.3:
		return Accuracy.GOOD
	elif difference <= 0.4:
		return Accuracy.MEH
	elif difference <= 0.5:
		return Accuracy.BAD
	else:
		return Accuracy.MISS

func get_accuracy_hold(lane: int) -> Accuracy:
	var time = get_real_time()
	var hold_notes = []
	for note_index in active_holds:
		hold_notes.append(notes[note_index])

	var closest_number = get_closest_number(hold_notes, time, lane)
	if closest_number == -1: # I should really write comments I have no idea what this means
		return Accuracy.MISS
	var note = hold_notes[closest_number]
	var difference = abs(note["time"]+note["hold_length"] - time)
	
	if difference <= 0.1:
		return Accuracy.SUPER
	elif difference <= 0.2:
		return Accuracy.GREAT
	elif difference <= 0.3:
		return Accuracy.GOOD
	elif difference <= 0.4:
		return Accuracy.MEH
	elif difference <= 0.5:
		return Accuracy.BAD
	else:
		return Accuracy.MISS

func accuracy_to_string(accuracy: Accuracy) -> String:
	if accuracy == 0:
		return "SUPER!"
	elif accuracy == 1:
		return "GREAT"
	elif accuracy == 2:
		return "GOOD"
	elif accuracy == 3:
		return "MEH"
	elif accuracy == 4:
		return "BAD"
	else:
		return "MISS"

func increase_score(accuracy: Accuracy):
	if accuracy == 0:
		scores[Accuracy.SUPER] += 1
	elif accuracy == 1:
		scores[Accuracy.GREAT] += 1
	elif accuracy == 2:
		scores[Accuracy.GOOD] += 1
	elif accuracy == 3:
		scores[Accuracy.MEH] += 1
	elif accuracy == 4:
		scores[Accuracy.BAD] += 1
	else:
		scores[Accuracy.MISS] += 1

func update_notes():
	for index in range(notes.size()):
		if abs(notes[index]["time"] - get_real_time()) > 5:
			continue
		var note_instance = note_instances[index]
		var note = notes[index]
		if note and note_instance:
			note_instance.position.y = 540 - (note.time - get_real_time()) * scroll_speed
			if note_instance.position.y >= 700 and note.being_held == false:
				note_instance.queue_free()
				scores[Accuracy.MISS] += 1

	for index in range(active_holds.size()):
		var note = notes[active_holds[index]]
		var note_instance = note_instances[active_holds[index]]
		if note_instance:
			var hold_end_time = note.time + note.hold_length
			var hold_size = (hold_end_time - get_real_time()) * scroll_speed
			note_instance.position.y = 540
			note_instance.get_node("Hold_Bar").size.y = hold_size # no longer broken :3 
			if hold_size <= 0.0:
				note_instance.get_node("Hold_Bar").size.y = 0

func handle_hit(note_index, accuracy):
	if note_instances[note_index]:
		
		increase_score(accuracy)
		
		if accuracy != Accuracy.MISS: # Not miss
			var cpu_particle
			match notes[note_index].lane:
				1:
					cpu_particle = $ColorRect/lane_1/CPUParticles2D
				2:
					cpu_particle = $ColorRect/lane_2/CPUParticles2D
				3:
					cpu_particle = $ColorRect/lane_3/CPUParticles2D
				4:
					cpu_particle = $ColorRect/lane_4/CPUParticles2D
			
			var new_colour
			var particle_amount
			
			if accuracy == Accuracy.SUPER:
				new_colour = Color(225, 52, 235)
				particle_amount = 32768
			if accuracy == Accuracy.GREAT:
				new_colour = Color(55, 235, 52)
				particle_amount = 16384
			if accuracy == Accuracy.GOOD:
				new_colour = Color(110, 235, 52)
				particle_amount = 8192
			if accuracy == Accuracy.MEH:
				new_colour = Color(235, 128, 52)
				particle_amount = 4096
			if accuracy == Accuracy.BAD:
				new_colour = Color(235, 64, 52)
				particle_amount = 2048
			
			new_colour = Color(new_colour.r/255.0, new_colour.g/255.0, new_colour.b/255.0)
			
			cpu_particle.color = new_colour
			cpu_particle.amount = particle_amount
					
			
			cpu_particle.emitting = false
			cpu_particle.restart()
			cpu_particle.emitting = true
			
			
		note_instances[note_index].queue_free()
	else:
		printerr("Note instance not found for " + str(note_index))
		
func format_info() -> String:
	var info_song_name = "[p]" + song_name + "[/p]"
	var time_in_song = "[p]" + str(snapped(get_real_time(), 0.1)) + "/" + str(song_end_time) + "[/p]"
	var super_score = "[p]SUPER: " + str(scores[Accuracy.SUPER]) + "[/p]"
	var great_score = "[p]GREAT: " + str(scores[Accuracy.GREAT]) + "[/p]"
	var good_score = "[p]GOOD: " + str(scores[Accuracy.GOOD]) + "[/p]"
	var meh_score = "[p]MEH: " + str(scores[Accuracy.MEH]) + "[/p]"
	var bad_score = "[p]BAD: " + str(scores[Accuracy.BAD]) + "[/p]"
	var miss_score = "[p]MISS: " + str(scores[Accuracy.MISS]) + "[/p]"
	var extra = ""
	if scores[Accuracy.MISS] == 0:
		extra += "[p]FULL CLEAR[/p]"
		
	return info_song_name + time_in_song + super_score + great_score + good_score + meh_score + bad_score + miss_score + extra

func handle_start_lane(lane):
	if level_editing == false:
		var accuracy = get_accuracy(lane)
		var closest_note = get_closest_number(notes, get_real_time(), lane)
		if notes[closest_note].is_hold == false:
			handle_hit(closest_note, accuracy)
		else:
			active_holds.append(closest_note)
			notes[active_holds[-1]].being_held = true
	else:
		editing_holds[lane] = get_real_time()


func handle_end_lane(lane):
	if level_editing == false:
		for note in active_holds.duplicate():
			if notes[note]["lane"] == lane:
				var accuracy = get_accuracy_hold(lane)
				print(accuracy)
				handle_hit(note, accuracy)
				active_holds.erase(note)
	else:
		if editing_holds.has(lane):
			var hold_start = editing_holds[lane]
			var hold_length = get_real_time() - hold_start
			if hold_length > 0.3:
				create_note(hold_start, lane, true, hold_length)
			else:
				create_note(hold_start, lane, false, 0)

			editing_holds.erase(lane)
		

func handle_input():
	if Input.is_action_just_pressed("lane_1"):
		handle_start_lane(1)	
	if Input.is_action_just_pressed("lane_2"):
		handle_start_lane(2)
	if Input.is_action_just_pressed("lane_3"):
		handle_start_lane(3)
	if Input.is_action_just_pressed("lane_4"):
		handle_start_lane(4)

	if Input.is_action_just_released("lane_1"):
		handle_end_lane(1)
	if Input.is_action_just_released("lane_2"):
		handle_end_lane(2)
	if Input.is_action_just_released("lane_3"):
		handle_end_lane(3)
	if Input.is_action_just_released("lane_4"):
		handle_end_lane(4)

	if Input.is_action_just_pressed("menu"):
		if level_editing == true:
			var save_data = {
				"notes": notes,
				"song_end_time": song_end_time,
				"song_name": song_name,
			}
			var editing_file = FileAccess.open("temp_level.json", FileAccess.WRITE)
			var string_data = JSON.stringify(save_data, "\t")
			editing_file.store_string(string_data)
			editing_file.close()
		else:
			get_tree().change_scene_to_file("res://select_menu.tscn")

	#print(active_holds)



func get_percentage_accuracy() -> float:
	var total_notes = len(notes) * 5
	var total_score = 0.0
	total_score += scores[Accuracy.SUPER] * 0
	total_score += scores[Accuracy.GREAT] * 1
	total_score += scores[Accuracy.GOOD] * 2
	total_score += scores[Accuracy.MEH] * 3
	total_score += scores[Accuracy.BAD] * 4
	total_score += scores[Accuracy.MISS] * 5
	var accuracy = total_score / total_notes
	var final_accuracy = (1.0 - (accuracy)) * 100
	return final_accuracy

func accuracy_to_rank(score: float) -> AccuracyRank:
	if score >= 99.0:
		return AccuracyRank.P
	elif score >= 96.0:
		return AccuracyRank.S
	elif score >= 90.0:
		return AccuracyRank.A
	elif score >= 80.0:
		return AccuracyRank.B
	elif score >= 75.0:
		return AccuracyRank.C
	else:
		return AccuracyRank.D

func handle_end_of_song():
	# First we should get the accuracy
	var percentage_accuracy = get_percentage_accuracy()
	var rank = accuracy_to_rank(percentage_accuracy)
	print("Your percentage accuracy is " + str(percentage_accuracy))
	if rank == AccuracyRank.P:
		print("AWESOME! You got a P rank!")
	elif rank == AccuracyRank.S:
		print("Sick! You got an S rank!")
	elif rank == AccuracyRank.A:
		print("Cool! You got an A rank!")
	elif rank == AccuracyRank.B:
		print("Nice, you got a B rank!")
	elif rank == AccuracyRank.C:
		print("You're getting there, you got a C rank.")
	elif rank == AccuracyRank.D:
		print("You're a bit off. You got a D rank.")

	if current_level == "1_1":
		if GlobalData.save["rank_1_1"] > rank:
			GlobalData.save["rank_1_1"] = rank
	elif current_level == "1_2":
		if GlobalData.save["rank_1_2"] > rank:
			GlobalData.save["rank_1_2"] = rank
	elif current_level == "1_3":
		if GlobalData.save["rank_1_3"] > rank:
			GlobalData.save["rank_1_3"] = rank
	elif current_level == "1_4":
		if GlobalData.save["rank_1_4"] > rank:
			GlobalData.save["rank_1_4"] = rank

	if current_level == "2_1":
		if GlobalData.save["rank_2_1"] > rank:
			GlobalData.save["rank_2_1"] = rank
	elif current_level == "2_2":
		if GlobalData.save["rank_2_2"] > rank:
			GlobalData.save["rank_2_2"] = rank
	elif current_level == "2_3":
		if GlobalData.save["rank_2_3"] > rank:
			GlobalData.save["rank_2_3"] = rank
	elif current_level == "2_4":
		if GlobalData.save["rank_2_4"] > rank:
			GlobalData.save["rank_2_4"] = rank

	if current_level == "3_1":
		if GlobalData.save["rank_3_1"] > rank:
			GlobalData.save["rank_3_1"] = rank
	elif current_level == "3_2":
		if GlobalData.save["rank_3_2"] > rank:
			GlobalData.save["rank_3_2"] = rank
	elif current_level == "3_3":
		if GlobalData.save["rank_3_3"] > rank:
			GlobalData.save["rank_3_3"] = rank
	elif current_level == "3_4":
		if GlobalData.save["rank_3_4"] > rank:
			GlobalData.save["rank_3_4"] = rank

	GlobalData.latest_rank = rank
	GlobalData.latest_accuracy = percentage_accuracy

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(GlobalData.save))
		file.close()

	get_tree().change_scene_to_file("res://game_end.tscn")

func _process(delta):
	if get_real_time() >= song_end_time:
		if song_ended == false:
			song_ended = true
			handle_end_of_song()
	else: # Song is currently being played
		#print(scores)
		$ColorRect/info.text = format_info()
		handle_input()
		update_notes()
