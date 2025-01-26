extends LineEdit

#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func _input(event):
	if event.is_action_pressed("ui_text_submit"):
		get_viewport().set_input_as_handled()
		emit_signal('text_submitted', text)
		#clear()
		#text = ""?
			
	#if event is InputEventMouseButton && \
	#event.button_index == MOUSE_BUTTON_LEFT && \
	#event.pressed == true && \
	#point_in_square(event.position, global_position, size) == true:
		#get_viewport().set_input_as_handled()
		#emit_signal('pressed') # since we set the input as handled before it reaches the GUI (button), we must manually emit the pressed signal.
