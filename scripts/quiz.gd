extends Node

const DICT_FILE = preload("res://scripts/kana_dict.gd")
var full_dict: Dictionary = DICT_FILE.full_dict

var to_quiz_dict = {}
var to_quiz_array = []
var quizing_eng_to_kana = false # false for kana to eng, true for eng to kana
var quizing_hira = true # false for kanakana, true for hirakana
var mixed_hira_kata_mode = false
var current_quiz_item = 0
var number_right = 0
var number_first_time_right = 0
var number_wrong = 0
var total_items_in_quiz = 0
var max_items_in_quiz: int = 10

var kanaButtonScene = preload("res://KanaButton.tscn")

#
func create_button(kana_key: String) -> KanaButton:
	#var instance = KanaButton.new()
	var instance = kanaButtonScene.instantiate()
	#instance.buttonText = button_text
	instance.set_key(kana_key)
	#instance.mouse_filter = Control.MOUSE_FILTER_PASS
	instance.kanaDict = full_dict[kana_key]
	#instance.set_mode(quizing_eng_to_kana, quizing_hira)
	#instance.theme(ResourceLoader("res://styles/kana_button_theme.tres"))
	instance.name = "kana_button_" + kana_key 
	return instance
	#
func _ready() -> void:
	for kana in full_dict:
		#var instance = kanaButtonScene.instantiate()
		#create_button(new_button, kana, full_dict[kana]["hira"])
		#var new_button = KanaButton.create(kana, full_dict[kana]["hira"])
		var new_button = create_button(kana)
		$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.add_child(new_button)
		new_button.set_mode(quizing_eng_to_kana, quizing_hira)
		new_button.kana_button_toggled.connect(_on_kana_toggled)
	load_game()
	print("ready")
	
	#call_deferred("change_screen_size")
	
#func change_screen_size():
	#emit_signal('item_rect_changed')
	
	
func answer_is_correct(answer : String, dict_item : Dictionary) :
	if quizing_eng_to_kana:
		if quizing_hira: # eng to hira
			return [answer == dict_item["hira"], dict_item["eng"], dict_item["hira"]]
		else: # eng to kata
			return [answer == dict_item["kata"], dict_item["eng"], dict_item["kata"]]
	else: # not quizing_eng_to_kana
		if quizing_hira:
			return [(answer.to_lower() in dict_item["answer"]), dict_item["hira"], dict_item["expl"]] # kana to eng
		else:
			return [(answer.to_lower() in dict_item["answer"]), dict_item["kata"], dict_item["expl"]] 
	return [false, "", ""]
	
func inputbox_text_submitted(new_text: String) -> void:
	#print("text submitted: ", new_text)
	#DisplayServer.virtual_keyboard_show("")
	if new_text == "":
		$MarginContainer/VBoxContainerQuiz/QuizTimer.stop()
		$MarginContainer/VBoxContainerQuiz/QuizTimer.emit_signal("timeout")
		return
		
	#$MarginContainer/VBoxContainerQuiz/InputBox.text = ""
	$MarginContainer/VBoxContainerQuiz/InputBox.grab_focus()
	$MarginContainer/VBoxContainerQuiz/InputBox.clear() # setting text to empty string manually sets keyboard to qwerty..
	
	var answered_correct = answer_is_correct(new_text, to_quiz_array[current_quiz_item])
	if answered_correct[0]:
		$MarginContainer/VBoxContainerQuiz/QuestionBox.text = "Correct!\n" + answered_correct[1]+ " is "+ answered_correct[2]
		number_right += 1
		if current_quiz_item < total_items_in_quiz:
			number_first_time_right += 1
			# this is for mixed mode, to make sure it adds it to the correct value
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_node("kana_button_" + to_quiz_array[current_quiz_item]["key"]).set_mode(quizing_eng_to_kana, quizing_hira)
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_node("kana_button_" + to_quiz_array[current_quiz_item]["key"]).add_answer(true)
		
		$MarginContainer/VBoxContainerQuiz/QuizTimer.wait_time = 1.0
	else:
		number_wrong += 1
		to_quiz_array.append(to_quiz_array[current_quiz_item])
		$MarginContainer/VBoxContainerQuiz/QuestionBox.text = "Wrong!\n" + answered_correct[1]+ " is "+ answered_correct[2]
		$MarginContainer/VBoxContainerQuiz/QuizTimer.wait_time = 2.0
		#if current_quiz_item < total_items_in_quiz:
		$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_node("kana_button_" + to_quiz_array[current_quiz_item]["key"]).add_answer(false)
			
	current_quiz_item += 1
	$MarginContainer/VBoxContainerQuiz/QuizProgressBar.value = float(number_right)/total_items_in_quiz*100
	#await get_tree().create_timer(1.0).timeout
	$MarginContainer/VBoxContainerQuiz/QuizTimer.start()
	await $MarginContainer/VBoxContainerQuiz/QuizTimer.timeout
	if current_quiz_item < len(to_quiz_array):
		next_quiz_item(current_quiz_item)
	else:
		#$MarginContainer/VBoxContainerQuiz/QuestionBox.text = str("Done!\n", round(float(number_right)/len(to_quiz)*100.0), "% correct")
		$MarginContainer/VBoxContainerQuiz/QuestionBox.text = str("Done!\n", round(float(number_first_time_right)/total_items_in_quiz*100.0), "% correct")

		$MarginContainer/VBoxContainerQuiz/QuizTimer.wait_time = 2.0
		$MarginContainer/VBoxContainerQuiz/QuizTimer.start()		
		$MarginContainer/VBoxContainerQuiz/InputBox.visible = false
		$MarginContainer/VBoxContainerQuiz/HBoxContainer/SubmitButton.visible = false
		#save_game()
		await $MarginContainer/VBoxContainerQuiz/QuizTimer.timeout
		$MarginContainer/VBoxContainerQuiz/QuizTimer.wait_time = 1.0
		#$MarginContainer/VBoxContainerQuiz.visible = false
		#$MarginContainer/VBoxContainerStart.visible = true
		$MarginContainer/VBoxContainerQuiz/InputBox.visible = true
		$MarginContainer/VBoxContainerQuiz/HBoxContainer/SubmitButton.visible = true
		set_start_screen_visible()


func _on_back_button_pressed():
	#$MarginContainer/VBoxContainerQuiz/InputBox.clear()
	#quizing_hira = not quizing_hira
	#_on_title_pressed() # because this is a toggle, we set it to the wrong value and toggle
	#$MarginContainer/VBoxContainerQuiz.visible = false
	#$MarginContainer/VBoxContainerStart.visible = true	
	#$MarginContainer/VBoxContainerQuiz/QuizProgressBar.value = 0
	set_start_screen_visible()

func set_start_screen_visible() -> void:
	$MarginContainer/VBoxContainerQuiz/InputBox.clear()
	quizing_hira = not quizing_hira
	_on_title_pressed() # because this is a toggle, we set it to the wrong value and toggle
	$MarginContainer/VBoxContainerStart.visible = true	
	$MarginContainer/VBoxContainerQuiz/QuizProgressBar.value = 0
	$MarginContainer/VBoxContainerQuiz.visible = false
	save_game()
	


var temp_quiz_dict = {}
var temp_quiz_array = []
func _on_start_button_pressed() -> void:
	_on_quiz_length_field_focus_exited() # update the max quiz length value
	save_game()
	# make sure we are not quizing the kana that have a katakan but not a hiragana
	if quizing_hira and not mixed_hira_kata_mode:
		temp_quiz_dict = to_quiz_dict.duplicate()
		temp_quiz_dict.erase("we")
		temp_quiz_dict.erase("wi")
		to_quiz_array = temp_quiz_dict.values()
	else:
		to_quiz_array = to_quiz_dict.values()
		
	if len(to_quiz_array) == 0:
		return
	# a b c d e
	to_quiz_array.shuffle() # we have all items once in random order
	# b d e c a
	if len(to_quiz_array) > max_items_in_quiz:
		to_quiz_array.resize(max_items_in_quiz)
		#b d e
	else:
		# if we want a longer quiz than the number of items: we add random duplicates	
		while len(to_quiz_array) < max_items_in_quiz:
			temp_quiz_array = to_quiz_array.duplicate() # not from dict values, to avoid the we and wi ones from being added
			temp_quiz_array.shuffle()
			# e b c d a
			to_quiz_array.append_array(temp_quiz_array)
		# b d e c a e b c d a
			
		to_quiz_array.resize(max_items_in_quiz) # all items in random order, same order for all sets
		# b d e c a e b c
		#to_quiz_array.shuffle()
		# no shuffling to reduce the chance of getting the same thing twice really close together
	
	total_items_in_quiz = len(to_quiz_array)
	current_quiz_item = 0
	number_right = 0
	number_wrong = 0
	number_first_time_right = 0
	# fixing/resetting the number in the box to the actual value of length of quiz (to remove any invalid input)
	#$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.value = (max_items_in_quiz)
	$MarginContainer/VBoxContainerStart.visible = false
	$MarginContainer/VBoxContainerQuiz.visible = true
	$MarginContainer/VBoxContainerQuiz/QuizProgressBar.value = 0
	
	current_quiz_item = 0
	next_quiz_item(current_quiz_item)

func next_quiz_item(_current_quiz_item) -> void:
	if quizing_eng_to_kana:
		if mixed_hira_kata_mode:
			if randi_range(0,1):
				$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["eng"] + " (hirakana)"
				quizing_hira = true
			else:
				$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["eng"] + " (katakana)"
				quizing_hira = false
		else:
			$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["eng"]
	else:
		if mixed_hira_kata_mode:
			if randi_range(0,1):
				$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["hira"]
			else:
				$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["kata"]	
		elif quizing_hira:
			$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["hira"]
		else:
			$MarginContainer/VBoxContainerQuiz/QuestionBox.text = to_quiz_array[_current_quiz_item]["kata"]
			
	#$MarginContainer/VBoxContainerQuiz/InputBox.clear()
	$MarginContainer/VBoxContainerQuiz/InputBox.grab_focus()
	


func _on_kana_to_eng_button_toggled(toggled_on: bool) -> void:
	#print("toggling kana_to_eng to: ", toggled_on)
	quizing_eng_to_kana = toggled_on
	if quizing_eng_to_kana:
		#mixed_hira_kata_mode = false # not possible to do this the other way around (at least not yet)
		#$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/MixedModeBox/MixedModeButton.disabled = true
		if quizing_hira:
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngLabel.text = "English to Hiragana"
		else:
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngLabel.text = "English to Katakana"
	else:
		#$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/MixedModeBox/MixedModeButton.disabled = false
		#mixed_hira_kata_mode = $MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/MixedModeBox/MixedModeButton.button_pressed
		if quizing_hira:
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngLabel.text = "Hiragana to English"
		else:
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngLabel.text = "Katakana to English"
		
	for child in $MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_children():
				child.set_mode(quizing_eng_to_kana, quizing_hira)


func _on_mixed_mode_button_toggled(toggled_on: bool) -> void:
	#print("mixed_mode_button toggled to: ", toggled_on)
	mixed_hira_kata_mode = toggled_on
	#if mixed_hira_kata_mode:
		#quizing_eng_to_kana = false
		#_on_kana_to_eng_button_toggled(quizing_eng_to_kana)
		#$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngButton.set_pressed_no_signal(quizing_eng_to_kana)




#
#func _on_quiz_length_field_focus_exited() -> void:
	#_on_quiz_length_field_text_submitted($MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.text)
#

func _on_quiz_length_field_focus_exited() -> void:
	max_items_in_quiz = int($MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.value)
	$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.value = max_items_in_quiz


#func _on_quiz_length_field_text_submitted(new_text: String):
	#print("number submitted: ", new_text)
	#if (new_text).is_valid_int() and int(new_text) > 0:
		#max_items_in_quiz = int(new_text)
		#$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.text = str(max_items_in_quiz)


func _on_kana_toggled(kanaKey: String, toggled_on: bool) -> void:
	if toggled_on:
		to_quiz_dict[kanaKey] = full_dict[kanaKey]
	else:
		to_quiz_dict.erase(kanaKey)


func _on_submit_button_pressed() -> void:
	inputbox_text_submitted($MarginContainer/VBoxContainerQuiz/InputBox.text)


func _on_title_pressed() -> void:
	if quizing_hira:
		quizing_hira = false
		$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/Title.text = " Katakana quiz "
	else:
		quizing_hira = true
		$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/Title.text = " Hirakana quiz "
	
	_on_kana_to_eng_button_toggled(quizing_eng_to_kana)
	
	for child in $MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_children():
				child.set_mode(quizing_eng_to_kana, quizing_hira)

func save():
	var save_dict = {
		"quizing_hira" : quizing_hira,
		"quizing_eng_to_kana" : quizing_hira,
		"max_items_in_quiz" : max_items_in_quiz,
		"mixed_hira_kata_mode" : mixed_hira_kata_mode		
	}
	return save_dict
	
func save_game():
	print("Saving game...")
	var save_file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		#print(node.name)
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	
	# Creates the helper class to interact with JSON.
	var json = JSON.new()
	var save_file = FileAccess.open("user://savegame.json", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()


		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
			
		#print(parse_result)

		# Get the data from the JSON object.
		var node_data = json.data
		
		#print(node_data)
		
		if node_data.has("quizing_hira"):
			quizing_hira = not node_data["quizing_hira"]
			_on_title_pressed() # because this is a toggle, we set it to the wrong value and toggle
		if node_data.has("quizing_eng_to_kana"):
			_on_kana_to_eng_button_toggled(node_data["quizing_eng_to_kana"])
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/HiraToEngBox/HiraToEngButton.set_pressed_no_signal(quizing_eng_to_kana)
		if node_data.has("max_items_in_quiz"):
			max_items_in_quiz = node_data["max_items_in_quiz"]
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/QuizLengthBox/QuizLengthField.value = max_items_in_quiz
		if node_data.has("mixed_hira_kata_mode"):
			_on_mixed_mode_button_toggled(node_data["mixed_hira_kata_mode"])
			$MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/MixedModeBox/MixedModeButton.set_pressed_no_signal(mixed_hira_kata_mode)
		if node_data.has("kana_key"):
			var kana_button = $MarginContainer/VBoxContainerStart/ScrollContainer/VBoxContainer/KanaTableContainer.get_node("kana_button_" + node_data["kana_key"])
			kana_button.load(node_data)
			kana_button.set_mode(quizing_eng_to_kana, quizing_hira)
		
