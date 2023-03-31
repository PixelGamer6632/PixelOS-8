extends Control

@onready var dragger = $Display/Toolbar/Dragger

var selected: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This _process() function is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _process(_delta):
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _on_image_view_m_pressed():
	self.hide()
