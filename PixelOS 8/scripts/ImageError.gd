extends Control

# This popup tells you that the path the game is trying to access in the user:// directory is null. Essentially, if you rename, move, or delete a file in the directory that exists as a file or wallpaper in the game will cause this message to show.

@onready var dragger = $ImageError/Toolbar/Dragger

var selected: bool = false

var mouse_offset = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This _process() function is how you can drag the window.
func _process(_delta):
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _on_ok_pressed():
	self.hide()

func _on_open_user_pressed():
	var project_dir = ProjectSettings.globalize_path("user://")
	OS.shell_open(project_dir)
