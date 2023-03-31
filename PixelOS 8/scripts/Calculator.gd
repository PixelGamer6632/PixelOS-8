extends Control

@onready var button = get_node("/root/Control/Calculator/Calculator/0/0")
@onready var button_container = get_node("/root/Control/Calculator/Calculator/")
@onready var dragger = $Calculator/Toolbar/Dragger
@onready var display = $Calculator/NumDisplay/Label

var selected: bool = false

var gen_level: int = 0
var button_pos: int = 0

var buttons = ["1","2","3","+","4","5","6","x","7","8","9","-","C","0","∻","="]

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in range(len(buttons)):
		var new_button = button.duplicate()
		var container_path = "/root/Control/Calculator/Calculator/" + str(gen_level)
		new_button.text = buttons[a]
		new_button.show()
		get_node(container_path).add_child.call_deferred(new_button)
		button_pos += 1
		if button_pos >= 4:
			gen_level += 1
			button_pos = 0

# This _process() function is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _process(_delta): # Called every frame.
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _on_calculator_x_pressed():
	display.text = "0"
	self.hide()

func _on_calculator_m_pressed():
	self.hide()
