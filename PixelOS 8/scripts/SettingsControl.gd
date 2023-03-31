extends Control

@onready var game = get_node("/root/Control")
@onready var wallpaper = get_node("/root/Control/Wallpaper")
@onready var pfp_menu = get_node("/root/Control/Menu/PFP")
@onready var pfp_launcher = get_node("/root/Control/Launcher/PFP")
@onready var menu_user_display = get_node("/root/Control/Menu/Name")
@onready var launcher_name = get_node("/root/Control/Launcher/Name")
@onready var username_display = $Settings/Username
@onready var section = $Settings/Categories/Section
@onready var categories = $Settings/Categories
@onready var change_menu = $ChangePassName
@onready var change_menu_title = $ChangePassName/Toolbar/Title
@onready var change_input = $ChangePassName/LineEdit
@onready var wallpaper_select = $Settings/Personalize/WallpaperSelect
@onready var pfp_file = $Settings/Personalize/ChoosePFP
@onready var privacy_timer = $Settings/About/PrivacySettings/Timer
@onready var privacy_button = $Settings/About/PrivacySettings
@onready var about_tab = $Settings/About
@onready var person_tab = $Settings/Personalize
@onready var system_tab = $Settings/System
@onready var wallpaper_file = $Settings/Personalize/ChooseWallpaper
@onready var dragger = $Settings/Toolbar/clicker
@onready var file_dialog = $Settings/Personalize/FileDialog
@onready var os_logo = $Settings/About/Logo
@onready var kernel_name = $Settings/System/KernelName
@onready var model_name = $Settings/System/ModelName
@onready var manufacturer = $Settings/System/Manufacturer
@onready var ram = $Settings/System/RAM
@onready var os_name = $Settings/WorldBuilding/OSName
@onready var currency = $Settings/WorldBuilding/Currency
@onready var power_source = $Settings/WorldBuilding/PowerSource
@onready var location = $Settings/Personalize/ChangeLocation

var wallpapers = {
		0: {"name": "Ocean","path": "res://assets/images/Wallpapers/Ocean.png"},
		1: {"name": "Mountains","path": "res://assets/images/Wallpapers/Mountains.jpg"},
		2: {"name": "PixelOS 7","path": "res://assets/images/Wallpapers/PixelOS7.png"},
		3: {"name": "Galaxy","path": "res://assets/images/Wallpapers/Galaxy.jpg"},
		4: {"name": "PixelOS 8","path": "res://assets/images/Wallpapers/PixelOS8Default.png"},
		5: {"name": "Pixel 5 Years","path": "res://assets/images/Wallpapers/Pixel5YearsNotWide.png"}
	}

var selected: bool = false
var can_drag: bool = false

var file_import_type = ""
var change_type = ""

var sections = ["System","Personalization","World Building","About"]

var path = "user://save_data.json"

var local_data = {}

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null

func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	print(wallpaper)
	local_data = load_game()
	username_display.text = local_data["username"]
	wallpaper_select.text = "Wallpaper"
	for a in range(len(sections)):
		var new_section = section.duplicate()
		new_section.show()
		new_section.text = sections[a]
		new_section.name = str(a)
		categories.add_child.call_deferred(new_section)
	for b in range(len(wallpapers)):
		wallpaper_select.get_popup().add_item(wallpapers[b]["name"])

func _on_my_pc_x_pressed():
	self.hide()
	about_tab.hide()
	person_tab.hide()
	system_tab.show()

func _on_change_x_pressed():
	change_menu.hide()

func _on_change_name_pressed():
	change_menu.show()
	change_type = "name"
	change_menu_title.text = "Change Profile Name"

func _on_confirm_pressed():
	if change_type == "name":
		local_data["username"] = str(change_input.text)
	else:
		local_data["password"] = str(change_input.text)
	save(local_data)
	change_input.text = ""
	
	username_display.text = local_data["username"]
	menu_user_display.text = local_data["username"]
	launcher_name.text = local_data["username"]

func _on_change_pass_pressed():
	change_menu.show()
	change_type = "password"
	change_menu_title.text = "Change Password"

func _on_wallpaper_select_item_selected(_index):
	var stylebox = StyleBoxTexture.new()
	var image = str(wallpapers[wallpaper_select.selected]["path"])
	var image2 = load(image)
	stylebox.texture = image2
	wallpaper.add_theme_stylebox_override("panel",stylebox)
	#wallpaper.texture = 
	local_data["wallpaper"] = wallpapers[wallpaper_select.selected]["path"]
	save(local_data)

func _on_choose_pfp_file_selected(path):
	var split_path = str(path).split(".")
	if split_path[1] == "png":
		var preview_tex = StyleBoxTexture.new()
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		preview_tex.texture = texture
		pfp_launcher.add_theme_stylebox_override("panel",preview_tex)
		pfp_menu.add_theme_stylebox_override("panel",preview_tex)
		local_data["pfp"] = str(path)
		save(local_data)

func _on_change_pfp_pressed():
	pfp_file.show()

func _on_privacy_settings_pressed():
	privacy_button.text = "Haha! Good one!"
	privacy_timer.start()

func _on_timer_timeout():
	privacy_button.text = "Privacy Settings"

# This _process() function is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _physics_process(_delta):
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _on_choose_wallpaper_file_selected(path):
	var split_path = str(path).split(".")
	#var wallpaper_tex = StyleBoxTexture.new()
	#var image = Image.load_from_file(path)
	#var texture = ImageTexture.create_from_image(image)
	#wallpaper_tex.texture = texture
	#wallpaper.add_theme_stylebox_override("panel",wallpaper_tex)
	if split_path[1] == "png":
		set_image(path,wallpaper)
		local_data["wallpaper"] = str(path)
		save(local_data)

func _on_choose_custom_wallpaper_pressed():
	wallpaper_file.show()

func _on_change_location_text_submitted(new_text):
	local_data["settings"]["personalization"]["location"] = str(new_text)
	save(local_data)
	local_data = load_game()

func _on_internet_active_toggled(button_pressed):
	local_data["settings"]["system"]["internet_active"] = button_pressed
	save(local_data)
	local_data = load_game()

func _on_os_name_text_submitted(new_text):
	local_data["settings"]["system"]["os_name"] = str(new_text)
	save(local_data)
	local_data = load_game()

func _on_currency_text_submitted(new_text):
	local_data["settings"]["world_building"]["currency"] = str(new_text)
	save(local_data)
	local_data = load_game()

func _on_power_source_text_submitted(new_text):
	local_data["settings"]["world_building"]["power_source"] = str(new_text)
	save(local_data)
	local_data = load_game()

func _on_change_logo_pressed():
	file_import_type = "custom_logo"
	file_dialog.show()

func set_image(photo,node):
	var stylebox = StyleBoxTexture.new()
	var image = Image.load_from_file(photo)
	var texture = ImageTexture.create_from_image(image)
	stylebox.texture = texture
	node.add_theme_stylebox_override("panel",stylebox)

func _on_file_dialog_file_selected(path):
	var split_path = str(path).split(".")
	match file_import_type:
		"custom_logo":
			if split_path[1] == "png":
				local_data["settings"]["personalization"]["os_logo"] = str(path)
				set_image(path,os_logo)
				save(local_data)

@onready var power_source_input = get_node("/root/Control/Settings/Settings/WorldBuilding/PowerSource")
@onready var currency_input = get_node("/root/Control/Settings/Settings/WorldBuilding/Currency")
func _on_apply_pressed():
	save(local_data)
	local_data = load_game()
	local_data["settings"]["world_building"]["currency"] = str(currency.text)
	local_data["settings"]["world_building"]["power_source"] = str(power_source_input.text)
	local_data["settings"]["system"]["kernel_name"] = str(kernel_name.text)
	local_data["settings"]["system"]["model_name"] = str(model_name.text)
	local_data["settings"]["personalization"]["location"] = str(location.text)

func _on_music_x_2_pressed():
	self.hide()
