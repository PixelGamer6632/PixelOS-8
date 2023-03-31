extends Button

@onready var launcher = get_node("/root/Control/Launcher")
@onready var close_launcher = get_node("/root/Control/CloseLauncher")
@onready var mypc = get_node("/root/Control/MyPC")
@onready var settings = get_node("/root/Control/Settings")
@onready var writer = get_node("/root/Control/Writer")
@onready var terminal = get_node("/root/Control/Terminal")
@onready var browser = get_node("/root/Control/Browser")
@onready var calculator = get_node("/root/Control/Calculator")
@onready var music_player = get_node("/root/Control/MusicPlayer")

# Called when the node enters the scene tree for the first time.
func _pressed():
	launcher.hide()
	close_launcher.hide()
	match self.name:
		"myPC":
			mypc.show()
		"Settings":
			settings.show()
		"Terminal":
			terminal.show()
		"Pixel_Browser":
			browser.show()
		"Calculator":
			calculator.show()
		"Music":
			music_player.show()
