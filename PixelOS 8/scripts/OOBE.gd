extends Control

@onready var page1 = get_node("/root/Control/Panel/Intro")
@onready var page2 = get_node("/root/Control/Panel/0")
@onready var next = $Panel/Next
@onready var page_num = $Panel/PageNum
@onready var valid_warning = get_node("/root/Control/Panel/0/ValidWarning")
@onready var valid_warning_timer = get_node("/root/Control/Panel/0/ValidWarning/Timer")
@onready var pfp_choose_file = get_node("/root/Control/Panel/0/ChoosePFPFile")
@onready var pfp_preview = get_node("/root/Control/Panel/0/PFPPreview")

@onready var page3 = get_node("/root/Control/Panel/1")
@onready var page4 = get_node("/root/Control/Panel/2")
# Called when the node enters the scene tree for the first time.

@export var data = {
	"username": "User",
	"password": "password",
	"pfp": "",
	"wallpaper": "res://assets/images/Wallpapers/PixelOS8Default.png",
	"setup_used": false,
	"num_of_files": 0,
	"files": [],
	"writer": {
		"autosave": false,
		"documents": 0,
		"autosave_wait_time": 300
	},
	"date_time": {
		"day": 0,
		"month": 0,
		"year": 0,
		"hour": 8,
		"minute": 29
	},
	"settings": {
		"world_building": {
			"currency": "$",
			"power_source": "",
		},
		"system": {
			"kernel_name": "Kernel",
			"model_name": "PixelOS PC",
			"os_name": "PixelOS 8",
			"manufacturer": "Pixel",
			"ram": 16,
			"internet_active": true
		},
		"personalization": {
			"location": "",
			"os_logo": "res://assets/icons/MyPC.png"
		}
	}
}

@export var local_data = {}

var page: int = 1
var amount_setup_to_enable: int = 3
var amount_used: int = 0

var path = "user://save_data.json"

var requirement_count = [3,4]

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
	if !FileAccess.file_exists(path):
		save(data)
		
	local_data = load_game()
	if local_data["setup_used"] == true:
		get_tree().change_scene_to_file("res://scenes/Desktop.tscn")

func _on_begin_pressed():
	page1.hide()
	page2.show()
	next.show()

func _on_next_pressed():
	match page:
		1:
			page2.hide()
			page3.show()
			next.disabled = true
			amount_used = 0
			amount_setup_to_enable = 1
			save(local_data)
		2:
			page3.hide()
			page4.show()
			save(local_data)
		_:
			local_data["setup_used"] = true
			save(local_data)
			get_tree().change_scene_to_file("res://scenes/Desktop.tscn")
	page += 1
	page_num.text = "Page " + str(page) + "/3"

func check_if_met_req():
	amount_used += 1
	if amount_used >= amount_setup_to_enable:
		next.disabled = false

var enter_amount0: int = 0
func _on_prof_name_text_submitted(new_text):
	local_data["username"] = str(new_text)
	if enter_amount0 == 0:
		check_if_met_req()
	enter_amount0 += 1

func _on_choose_pfp_pressed():
	pfp_choose_file.show()

# This will set the dispay preview panel's StyleBoxTexture to the image you select.
var enter_amount_pfp: int = 0
func _on_choose_pfp_file_file_selected(path):
	var split_path = str(path).split(".")
	if split_path[1] == "png":
		var preview_tex = StyleBoxTexture.new()
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		preview_tex.texture = texture
		pfp_preview.add_theme_stylebox_override("panel",preview_tex)
		local_data["pfp"] = str(path)
		if enter_amount_pfp == 0:
			check_if_met_req()
		enter_amount_pfp += 1
	else:
		valid_warning.show()

var enter_amount1: int = 0
func _on_password_text_submitted(new_text):
	local_data["password"] = str(new_text)
	if enter_amount1 == 0:
		check_if_met_req()
	enter_amount1 += 1

var enter_amount2: int = 0
func _on_day_text_submitted(new_text):
	local_data["date_time"]["day"] = int(new_text)
	if enter_amount2 == 0:
		check_if_met_req()
	enter_amount2 += 1

var enter_amount3: int = 0
func _on_month_text_submitted(new_text):
	local_data["date_time"]["month"] = int(new_text)
	if enter_amount3 == 0:
		check_if_met_req()
	enter_amount3 += 1

var enter_amount4: int = 0
func _on_year_text_submitted(new_text):
	local_data["date_time"]["year"] = int(new_text)
	if enter_amount4 == 0:
		check_if_met_req()
	enter_amount4 += 1

var enter_amount5: int = 0
func _on_location_text_submitted(new_text):
	local_data["location"] = str(new_text)
	if enter_amount5 == 0:
		check_if_met_req()
	enter_amount5 += 1

func _on_valid_warning_visibility_changed():
	#valid_warning_timer.start()
	pass

func _on_timer_timeout():
	if valid_warning.visible == true:
		valid_warning.hide()
