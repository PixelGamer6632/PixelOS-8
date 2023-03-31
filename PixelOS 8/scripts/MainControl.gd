extends Control

@onready var menu = $Menu
@onready var launcher = $Launcher
@onready var close_launcher = $CloseLauncher
@onready var dock_container = $Dock/Icons
@onready var mypc_icon = $Dock/Icons/myPC
@onready var power_options = $Menu/Power
@onready var pfp_menu = $Menu/PFP
@onready var pfp_launcher = $Launcher/PFP
@onready var menu_user_display = $Menu/Name2
@onready var calender_day = get_node("/root/Control/Menu/Calender/0/0")
@onready var login = $Login
@onready var dock = $Dock
@onready var toolbar = $Toolbar
@onready var login_user = $Login/Username
@onready var login_pfp = $Login/PFP
@onready var time_til_load = $TimeToLoadDock
@onready var image_error = $ImageError
@onready var wallpaper = $Wallpaper
@onready var menu_button = $Toolbar/MenuOpen
@onready var time_label = $Toolbar/Time
@onready var launcher_time_label = $Launcher/Panel/Time
@onready var logo = $Settings/Settings/About/Logo

@onready var launcher_app = get_node("/root/Control/Launcher/VBoxContainer/0/LauncherApp")
@onready var launcher_name = get_node("/root/Control/Launcher/Name")
@onready var username_display = get_node("/root/Control/Settings/Settings/Username")

@export var local_data = {}

var max_apps_on_launcher_row: int = 5
var selected_column: int = 0
var app_pos: int = 0
var week_size: int = 7
var selected_week: int = 0
var day_pos: int = 0
var secconds: int = 0

var time_side = "AM"

var containers = "/root/Control/Launcher/VBoxContainer/0"

var dock_apps = {
	0: {
		"name": "Pixel_Browser",
		"icon": "res://assets/icons/newbrowser(1).svg"
	},
	1: {
		"name": "Settings",
		"icon": "res://assets/icons/settings.svg"
	},
	2: {
		"name": "Pixel_Store",
		"icon": "res://assets/icons/PixelStore.svg"
	},
	3: {
		"name": "Terminal",
		"icon": "res://assets/icons/Terminal.svg"
	},
	4: {
		"name": "Pixel_Office",
		"icon": "res://assets/icons/Office(1).svg"
	},
	5: {
		"name": "Writer",
		"icon": "res://assets/icons/Writer.svg"
	},
	6: {
		"name": "Presenter",
		"icon": "res://assets/icons/Presenter(1).svg"
	},
	7: {
		"name": "Spreadsheets",
		"icon": "res://assets/icons/Spreadsheets.svg"
	},
	8: {
		"name": "Music",
		"icon": "res://assets/icons/music.svg"
	}
}

var launcher_apps = {
	0: {"path": "res://assets/icons/newbrowser(1).svg","name": "Pixel_Browser"},
	1: {"path": "res://assets/icons/settings.svg","name": "Settings"},
	2: {"path": "res://assets/icons/PixelStore.svg","name": "Pixel_Store"},
	3: {"path": "res://assets/icons/Terminal.svg","name": "Terminal"},
	4: {"path": "res://assets/icons/Office(1).svg","name": "Pixel_Office"},
	5: {"path": "res://assets/icons/Writer.svg","name": "Writer"},
	6: {"path": "res://assets/icons/Presenter(1).svg","name": "Presenter"},
	7: {"path": "res://assets/icons/Spreadsheets.svg","name": "Spreadsheets"},
	8: {"path": "res://assets/icons/music.svg","name": "Music"},
	9: {"path": "res://assets/icons/Calculator.svg","name": "Calculator"}
}

var path = "user://save_data.json"

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

func set_image(node,file):
	var stylebox = StyleBoxTexture.new()
	var split_image = str(file).split("://")
	if split_image[0] == "user":
		var image = Image.new()
		var photo = FileAccess.open(file,FileAccess.READ)
		var buffer = photo.get_buffer(photo.get_length())
		
		image.load_png_from_buffer(buffer)
		var texture = ImageTexture.create_from_image(image)
		stylebox.texture = texture
		node.add_theme_stylebox_override("panel",stylebox)
	elif split_image[0] == "res":
		var image = ResourceLoader.load(str(file))
		var texture = ImageTexture.create_from_image(image)
		stylebox.texture = load(file)
		node.add_theme_stylebox_override("panel",stylebox)

# Called when the node enters the scene tree for the first time.
func _ready():
	power_options.text = "Power"
	local_data = load_game()
	print(local_data["wallpaper"])

	for a in range(len(dock_apps)): # Icons on the dock are preloaded here.
		var new_app = mypc_icon.duplicate()
		new_app.icon = load(dock_apps[a]["icon"])
		new_app.name = dock_apps[a]["name"]
		dock_container.add_child.call_deferred(new_app)
	for b in range(len(launcher_apps)): # Launcher icons are preloaded here.
		var new_launcher_app = launcher_app.duplicate()
		new_launcher_app.icon = load(launcher_apps[b]["path"])
		new_launcher_app.name = launcher_apps[b]["name"]
		new_launcher_app.set_scale(Vector2(1,1))
		new_launcher_app.show()
		
		get_node("/root/Control/Launcher/VBoxContainer/" + str(selected_column)).add_child.call_deferred(new_launcher_app)
		app_pos += 1
		if app_pos >= max_apps_on_launcher_row:
			selected_column += 1
			app_pos = 0
			if selected_column > 5:
				selected_column -= 1
		
	for c in range(31+4): # Calender buttons are preloaded here.
		var new_day = calender_day.duplicate()
		new_day.text = str(c+1)
		new_day.name = str(c+1)
		new_day.show()
		if c > 30:
			new_day.flat = true
			new_day.text = ""
		get_node("/root/Control/Menu/Calender/" + str(selected_week)).add_child.call_deferred(new_day)
		day_pos += 1
		if day_pos >= week_size:
			selected_week += 1
			day_pos = 0
			if selected_week > 5:
				selected_week -= 1
	
	# Applies the saved username to all username labels.
	username_display.text = local_data["username"]
	menu_user_display.text = local_data["username"]
	launcher_name.text = local_data["username"]
	login_user.text = local_data["username"]
	
	menu_button.text = str(local_data["date_time"]["month"]) + "-" + str(local_data["date_time"]["day"]) + "-" + str(local_data["date_time"]["year"])
	time_label.text = str(local_data["date_time"]["hour"]) + ":" + str(local_data["date_time"]["minute"]) + ":" + str(secconds) + " " + time_side
	
	# Applies saved wallpaper to the wallpaper panel node and the saved profile picture to all pfp panel nodes.
	if FileAccess.file_exists(local_data["pfp"]) or FileAccess.file_exists(local_data["wallpaper"]):
		set_image(logo,local_data["settings"]["personalization"]["os_logo"])
		set_image(pfp_launcher,local_data["pfp"])
		set_image(pfp_menu,local_data["pfp"])
		set_image(login_pfp,local_data["pfp"])
		set_image(wallpaper,local_data["wallpaper"])
	else:
		image_error.show() # If PixelOS cannot find the image the path is leading it to, it will display this error popup.

func _on_open_launcher_pressed():
	launcher.show()
	close_launcher.show()

func _on_close_launcher_pressed():
	launcher.hide()
	close_launcher.hide()

func _on_menu_open_pressed():
	menu.visible = !menu.visible

func _on_password_text_submitted(new_text):
	if new_text == local_data["password"]:
		login.hide()
		toolbar.show()
		time_til_load.start()

func _on_time_to_load_dock_timeout(): # When the game loads, the dock pops up from the bottom of the screen. This is how it works.
	dock.show()
	var dock_tween = create_tween()
	dock_tween.tween_property(dock,"position",Vector2(dock.position.x,dock.position.y-138),0.3)

func _on_time_length_timeout(): # Date & Time function with this code.
	secconds += 1
	if secconds == 60:
		local_data["date_time"]["minute"] += 1
		secconds = 0
		if local_data["date_time"]["minute"] == 60:
			local_data["date_time"]["minute"] = 0
			local_data["date_time"]["hour"] += 1
			if local_data["date_time"]["hour"] == 12:
				local_data["date_time"]["day"] += 1
				if local_data["date_time"]["day"] == 32:
					local_data["date_time"]["day"] = 1
					local_data["date_time"]["month"] += 1
					if local_data["date_time"]["month"] == 13:
						local_data["date_time"]["month"] = 1
						local_data["date_time"]["year"] += 1
				if local_data["date_time"]["hour"] == 13:
					local_data["date_time"]["hour"] = 1
	menu_button.text = str(local_data["date_time"]["month"]) + "-" + str(local_data["date_time"]["day"]) + "-" + str(local_data["date_time"]["year"])
	time_label.text = str(local_data["date_time"]["hour"]) + ":" + str(local_data["date_time"]["minute"]) + ":" + str(secconds)
	launcher_time_label.text = str(local_data["date_time"]["hour"]) + ":" + str(local_data["date_time"]["minute"]) + ":" + str(secconds)
	#save(local_data)

func _on_power_item_selected(_index):
	match power_options.get_item_text(power_options.selected):
		"Shut Down":
			save(local_data)
			get_tree().quit()
		"Restart":
			save(local_data)
			get_tree().change_scene_to_file("res://scenes/Desktop.tscn")
