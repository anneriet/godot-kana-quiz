extends Button

#func _ready() -> void:
	#set_focus
	#.FocusMode(FOCUS_NONE)
	
# if using _input: does not steal focus from the edit but does reset the keyboard to qwerty.. 
# (but does reopen the keyboard with the correct language when the inputbox grabs the focus again
func _gui_input(event):
	if event is InputEventMouseButton && \
	event.button_index == MOUSE_BUTTON_LEFT && \
	event.pressed == true && \
	point_in_square(event.position, global_position, size) == true:
		get_viewport().set_input_as_handled()
		emit_signal('pressed') # since we set the input as handled before it reaches  the GUI (button), we must manually emit the pressed signal.
		#text = 	'click'
	elif event is InputEventScreenTouch && \
	event.pressed == true:
		if point_in_square(event.position, global_position, size) == true:
			#text = 	'touch'
			get_viewport().set_input_as_handled()
			emit_signal('pressed') # since we set the input as handled before it reaches  the GUI (button), we must manually emit the pressed signal.
			#accept_event()
			#release_focus()
			
	
	
func point_in_square(_inner, _outer, _size):
	if _inner.x > _outer.x && \
		_inner.y > _outer.y && \
		_inner.x < _outer.x + _size.x && \
		_inner.y < _outer.y + _size.y:
		return true
	return false
