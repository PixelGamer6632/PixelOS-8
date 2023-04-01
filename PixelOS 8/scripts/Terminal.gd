extends Control

@onready var command_line = $Terminal/CommandLine
@onready var title = $Terminal/Toolbar/Title
@onready var dragger = $Terminal/Toolbar/Dragger
@onready var game = get_node("/root/Control")

var commands = [
	"open",
	"title",
	"help",
	"neofetch",
	"quit",
	"spam",
	"print",
	"savedata"
]

var text_logo = """           ,(((((((((((((((((((((((*          
	 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
   (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
  /@@@@@@@(((((((((((((((((((((((((&@@@@@@&  
  @@@@@@(  @@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@  
  @@@@@@(  @@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@  
  @@@@@@(  @@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@  
  @@@@@@(  @@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@  
  @@@@@@(  @@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@  
  @@@@@@@                           /@@@@@@@  
  @@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@  
  @@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@  
  @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@  
  .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%  
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/   
	  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.     """

var path = "user://save_data.json"

var selected: bool = false
var open: bool = false

var local_data = {}

func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content
	
func _ready():
	local_data = load_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# The top if statement is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _process(_delta):
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false
	
	# Commands
	if Input.is_action_just_pressed("execute_command") and open == true:
		if commands[2] in command_line.text: # help
			command_line.text += str(commands)
		elif commands[3] in command_line.text: # pixelos
			command_line.text += "\n" + text_logo + "\n" + "PixelOS 8. Kernal version 1.0.1."
		elif commands[3] in command_line.text: # quit
			self.hide()
			command_line.text = ""
		elif commands[7] in command_line.text: # savedata
			command_line.text += "\n" + str(local_data)
		else:
			var command_split = command_line.text.split(" ")
			if commands[0] == command_split[0]: # open [node]
				var node_path = "/root/Control/" + command_split[1]
				if game.has_node(node_path):
					get_node(node_path).show()
			elif commands[1] == command_split[0]: # title [string]
				title.text = str(command_split[1])
			elif commands[5] == command_split[0]: # spam [message] [amount]
				for a in range(int(command_split[2])):
					command_line.text += "\n" + command_split[1]
			elif commands[6] == command_split[0]: # print [message]
				command_line.text += "\n" + command_split[1]
			else:
				command_line.text += "\n" + '"' + command_split[0] + '"' + " is not recognized as an internal or external command."
		
		command_line.text += "\nPress backspace to continue."
		command_line.editable = false
	elif Input.is_action_just_pressed("any_key"):
		command_line.text = ""
		command_line.editable = true

func _on_terminal_x_pressed():
	self.hide()
	command_line.text = ""

func _on_visibility_changed():
	if self.visible == true:
		open = true
	else:
		open = false

func _on_terminal_m_pressed():
	self.hide()
