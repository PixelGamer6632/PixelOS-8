extends Control

@onready var enter_doc_name = $Writer/DocumentName
@onready var window_title = $Writer/Toolbar/Title
@onready var char_count = $Writer/Infobar/CharCount
@onready var word_count = $Writer/Infobar/WordCount
@onready var doc = $Writer/TextEdit
@onready var file_options = $Writer/File
@onready var settings = $Settings
@onready var dragger1 = $Writer/Toolbar/Dragger
@onready var dragger2 = $Settings/Toolbar/Dragger2
@onready var time_til_hide = $Writer/SaveMessage/TimeTilHide
@onready var save_message = $Writer/SaveMessage
@onready var auto_save_duration = $AutoSaveDuration
@onready var file_dialog = $Writer/FileDialog

@onready var mypc = get_node("/root/Control/MyPC")

@export var local_data = {}
@export var selected_file = {}

var selected: bool = false

var text_split = []

var path = "user://save_data.json"

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

func save_document(): # Saves word count, character count, and the document text itself to the open file data.
	local_data = load_game()
	local_data["files"][selected_file["id"]][selected_file["id"]]["text"] = str(doc.text)
	local_data["files"][selected_file["id"]][selected_file["id"]]["char_count"] = len(doc.text)
	local_data["files"][selected_file["id"]][selected_file["id"]]["word_count"] = len(text_split)
	selected_file["text"] = str(doc.text)
	selected_file["char_count"] = len(doc.text)
	selected_file["word_count"] = len(text_split)
	save(local_data)
	mypc.selected_file_data = selected_file
	save_message.show()
# Called when the node enters the scene tree for the first time.
func _ready():
	local_data = load_game()
	file_options.text = "File"

func _on_document_name_text_submitted(_new_text):
	window_title.text = str(enter_doc_name.text) + " - Pixel Writer"
	local_data["files"][mypc.selected_file_data["id"]]["text_name"] = enter_doc_name.text

func _on_text_edit_text_changed():
	text_split = str(doc.text).split(" ")
	char_count.text = "Characters - " + str(len(doc.text))
	word_count.text = "Words - " + str(len(text_split))

func _on_autosave_check_toggled(button_pressed):
	local_data["writer"]["autosave"] = button_pressed
	save(local_data)

func _on_file_item_selected(_index):
	match file_options.text:
		"Save":
			save_document()
		"Export as .txt":
			var new_file = FileAccess.open("user://" + str(selected_file["name"]) + ".txt",FileAccess.WRITE)
			new_file.store_string(str(doc.text))
		"Import .txt":
			file_dialog.show()

func _on_my_pc_x_pressed():
	self.hide()
	mypc.selected_file_data = {}

func _on_settings_x_pressed():
	settings.hide()

func _on_settings_pressed():
	settings.show()

# This _process() function is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _process(_delta): # Called every frame.
	if selected == true:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger1.button_pressed == true or dragger2.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _on_auto_save_duration_timeout():
	if local_data["writer"]["autosave"] == true:
		save_document()

func _on_save_message_visibility_changed():
	if save_message.visible == true:
		time_til_hide.start()

func _on_time_til_hide_timeout():
	save_message.hide()

func _on_line_edit_text_submitted(new_text):
	if new_text.is_valid_integer():
		auto_save_duration.wait_time = int(new_text)
		save(local_data)
		local_data = load_game()

func _on_file_dialog_file_selected(path):
	var path_split = str(path).split(".")
	if path_split[1] == "txt":
		var file = FileAccess.open(path,FileAccess.READ)
		#var string_from_file = file.get_as_text()
		doc.text = str(file.get_as_text())
		char_count.test = len(doc.text)
		word_count.text = len(doc.text.split(" "))
