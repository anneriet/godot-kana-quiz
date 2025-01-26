class_name KanaButton extends Button

var buttonText: String
var kanaKey: String
var kanaDict = {}
#{"hira" : "あ", "eng" : "a" , "kata" : "ア", "answer" : ["a"], "expl" : "a"}

#var default_font = $Label.get_theme_default_font()
var default_font = ThemeDB.fallback_font

var standard_text_length = default_font.get_string_size("ma").x

#TODO: need this data per type of practice..
# and keep track of which items i have selected
enum QUIZ_MODE {HIRA_TO_ENG, KATA_TO_ENG, ENG_TO_HIRA, ENG_TO_KATA}
var save_info = {"kana_key" : "", 
				"selected" : false,
				 str(QUIZ_MODE.HIRA_TO_ENG): {"number_right" : 0, "number_wrong" : 0, "times_practiced" : 0},
				 str(QUIZ_MODE.KATA_TO_ENG): {"number_right" : 0, "number_wrong" : 0, "times_practiced" : 0},
				 str(QUIZ_MODE.ENG_TO_HIRA): {"number_right" : 0, "number_wrong" : 0, "times_practiced" : 0},
				 str(QUIZ_MODE.ENG_TO_KATA): {"number_right" : 0, "number_wrong" : 0, "times_practiced" : 0},
				}

signal kana_button_toggled(key, toggled_on)

@onready var progress_bar = get_node("ProgressBar")

var current_mode: String = str(QUIZ_MODE.HIRA_TO_ENG)

#"a" : {"hira" : "あ", "eng" : "a" , "kata" : "ア", "answer" : ["a"], "expl" : "a"}

#static func create(kana_key: String, button_text: String) -> KanaButton:
	#var instance = KanaButton.new()
	#instance.buttonText = button_text
	#instance.kanaKey = kana_key
	#instance.mouse_filter = Control.MOUSE_FILTER_PASS
	##instance.theme(ResourceLoader("res://styles/kana_button_theme.tres"))
	#if button_text == "":
		#instance.disabled = true
	#return instance
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_button_text(buttonText)
	#expand_icon = true
	if disabled:
		progress_bar.visible = false
	
	#size_flags_horizontal = Control.SIZE_EXPAND_FILL
	toggled.connect(_on_toggled)
	#call_deferred("make_square_buttons")
	
#func make_square_buttons():
	##print(size)
	#custom_minimum_size.y = size.x


func _on_toggled(toggled_on: bool) -> void:
	#print(kanaKey, "was just toggled")
	#print(size)
	save_info["selected"] = toggled_on
	kana_button_toggled.emit(kanaKey, toggled_on)
	

func set_key(_key: String) -> void:
	kanaKey = _key
	save_info["kana_key"] = _key
	
func set_button_text(button_text: String) -> void:
	buttonText = button_text
	if buttonText == "":
		disabled = true
		progress_bar.visible = false
	else:
		disabled = false
		progress_bar.visible = true
	$Label.text = buttonText
	#$Label.text = "[center]" + buttonText + "[/center]"
	
	#_on_item_rect_changed()
	custom_minimum_size.y = get_viewport_rect().size.x/NUMBER_OF_COLS
	#call_deferred("change_label_size")


#func change_label_size():
	#custom_minimum_size.x = $Label.size.x
	#emit_signal('item_rect_changed')

	
	
	#$Label.text = buttonText

func set_mode(quizing_eng_to_kana: bool, quizing_hira: bool) -> void:
	if quizing_eng_to_kana:
		#$Label.add_theme_font_size_override("font_size", 90)
		$Label.add_theme_font_size_override("normal_font_size", 110)
		if quizing_hira:
			current_mode = str(QUIZ_MODE.ENG_TO_HIRA)
			if kanaDict["hira"] == "":
				set_button_text("")
			else:
				set_button_text(kanaDict["eng"])
		else:
			current_mode = str(QUIZ_MODE.ENG_TO_KATA)
			set_button_text(kanaDict["eng"])
	else:
		#$Label.add_theme_font_size_override("font_size", 150)
		$Label.add_theme_font_size_override("normal_font_size", 150)
		if quizing_hira:
			current_mode = str(QUIZ_MODE.HIRA_TO_ENG)
			set_button_text(kanaDict["hira"])
		else:
			current_mode = str(QUIZ_MODE.KATA_TO_ENG)
			set_button_text(kanaDict["kata"])
			#
		#$Name.font_size = 32
		#while $Name.font.get_string_size($Name.text, $Name.horizontal_alignment, -1, $Name.font_size).x > $Name.width:
			#$Name.font_size -= 1
	set_progressbar(save_info[current_mode]["number_right"], save_info[current_mode]["number_wrong"],save_info[current_mode]["times_practiced"])
		#print("current mode: ", current_mode, "save_info: ", save_info)
		#print(save_info)
	
	
func set_progressbar(times_right: int, times_wrong: int, times_practiced: int):
	if times_practiced < 10:
		progress_bar.value = float(times_practiced-times_wrong)/10.0
	else:
		progress_bar.value = float(times_practiced-times_wrong)/times_practiced
		
				
func add_answer(was_correct: bool):
	if was_correct:
		save_info[current_mode]["number_right"] += 1
		if int(save_info[current_mode]["number_right"]) % 5 == 0 \
				and save_info[current_mode]["number_wrong"] > 0:
			save_info[current_mode]["number_wrong"] -= 1 # erases one wrong answer
	else:
		save_info[current_mode]["number_wrong"] += 1
	save_info[current_mode]["times_practiced"] += 1
	
	#print(save_info[current_mode])
	set_progressbar(save_info[current_mode]["number_right"], save_info[current_mode]["number_wrong"],save_info[current_mode]["times_practiced"])

func load(_save_info: Dictionary):
	#print(save_info)
	#if _save_info.has(QUIZ_MODE.HIRA_TO_ENG):
	save_info = _save_info
	if save_info["selected"]:
		_on_toggled(true)
		button_pressed = true
	set_progressbar(save_info[current_mode]["number_right"], save_info[current_mode]["number_wrong"],save_info[current_mode]["times_practiced"])
	
	#if save_info[current_mode]["times_practiced"] < 10:
		#progress_bar.value = float(save_info[current_mode]["times_practiced"]-save_info[current_mode]["number_wrong"])/10
	#else:
		#progress_bar.value = float(save_info[current_mode]["times_practiced"]-save_info[current_mode]["number_wrong"])/save_info[current_mode]["times_practiced"]
		
	#progress_bar.value = float(save_info[current_mode]["times_practiced"]-save_info[current_mode]["number_wrong"])/save_info[current_mode]["times_practiced"]
	
func save():
	return save_info
	

const NUMBER_OF_COLS = 5
func _on_item_rect_changed() -> void:
	
	#print(size)
	custom_minimum_size.y = get_viewport_rect().size.x/NUMBER_OF_COLS
	custom_minimum_size.x = $Label.size.x
	
	#get_string_size(buttonText)
	#if default_font.get_string_size(buttonText).x  > standard_text_length:
		#print("long text: ", buttonText, ": ", $Label.size.x, ", ", get_viewport_rect().size.x, ", a/b ", $Label.size.x/ get_viewport_rect().size.x)
	#if $Label.size.x/ get_viewport_rect().size.x > 1/NUMBER_OF_COLS:
		#custom_minimum_size.x = $Label.size.x # get_viewport_rect().size.x/NUMBER_OF_COLS
		#print((get_viewport_rect().size.x*default_font.get_string_size(buttonText).x)/(NUMBER_OF_COLS*standard_text_length))
		#set_stretch_ratio(2)
		#custom_minimum_size.x = (get_viewport_rect().size.x*default_font.get_string_size(buttonText).x)/(NUMBER_OF_COLS*standard_text_length)
	#else:
		#custom_minimum_size.x = 0
		#set_stretch_ratio(1)
		
	#set_button_text(str(size_flags_stretch_ratio))
