extends Button

@onready var file_display_name = get_node("/root/Control/MyPC/MyPC/FileInfo/FileName")
@onready var game = get_node("/root/Control/MyPC")
@onready var mypc = get_node("/root/Control/MyPC")
@onready var image_preview = get_node("/root/Control/MyPC/MyPC/FileInfo/ImagePreview")
@onready var no_prev_label = get_node("/root/Control/MyPC/MyPC/FileInfo/NoPrev")

@onready var image_view_display = get_node("/root/Control/ImageView/Display")

@onready var char_count = get_node("/root/Control/MyPC/MyPC/FileInfo/CharCount")
@onready var word_count = get_node("/root/Control/MyPC/MyPC/FileInfo/WordCount")
@onready var writer = get_node("/root/Control/Writer")

@onready var confirm = get_node("/root/Control/MyPC/CleanWarning/Confirm")

@export var local_file_data = {}
@export var id = 0

var local_data = {}

var path = "user://save_data.json"

func save_game(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	local_data = load_game()
	confirm.pressed.connect(_on_confirm_pressed)

func _pressed():
	print(local_file_data)
	local_data = load_game()
	var split_name = self.text.split(".")
	file_display_name.text = split_name[0]
	char_count.hide()
	word_count.hide()
	image_preview.hide()
	match local_file_data["file_type"]:
		"png":
			print("detected")
			#print(local_data["files"][id][id]["image"])
			var preview_tex = StyleBoxTexture.new()
			var image = Image.load_from_file(local_file_data["image"])
			var texture = ImageTexture.create_from_image(image)
			preview_tex.texture = texture
			image_preview.show()
			image_preview.add_theme_stylebox_override("panel",preview_tex)
			image_view_display.add_theme_stylebox_override("panel",preview_tex)
		"wdoc":
			char_count.text = "Characters - " + str(local_file_data["char_count"])
			word_count.text = "Words - " + str(local_file_data["word_count"])
			word_count.show()
			char_count.show()
	no_prev_label.show()
	mypc.selected_file_data = local_file_data
	writer.selected_file = local_file_data

func _on_confirm_pressed():
	if self.text != "File.file":
		self.queue_free()
