extends Control

@onready var create_file = $CreateFile
@onready var create_button = $CreateFile/Create
@onready var mypc_file = $MyPC/ScrollFiles/Files/File

@onready var new_file_name = $CreateFile/LineEdit
@onready var add_image = $CreateFile/ChooseImage
@onready var open_res = $CreateFile/OpenRes
@onready var file_dialog = $MyPC/FileDialog
@onready var core_folder = $MyPC/Folders/Folder
@onready var core_folder_container = $MyPC/Folders
@onready var file_options = $CreateFile/FileOptions
@onready var dragger = $MyPC/Toolbar/Dragger
@onready var dragger2 = $CreateFile/Toolbar/Dragger2
@onready var audio_dialog = $CreateFile/AudioChoose
@onready var audio_button = $CreateFile/ChooseAudio
@onready var cover_art = $CreateFile/ChooseCover
@onready var clean_warning = $CleanWarning
@onready var confirm = $CleanWarning/Confirm
@onready var image_preview = $MyPC/FileInfo/ImagePreview

@onready var files = $MyPC/ScrollFiles/Files
@onready var images = $MyPC/ScrollFilesImages/Files
@onready var documents = $MyPC/ScrollFilesDocuments/Files
@onready var audio = $MyPC/ScrollFilesAudio/Files
@onready var videos = $MyPC/ScrollFilesVideos/Files

@onready var image_view = get_node("/root/Control/ImageView")
@onready var music_player = get_node("/root/Control/MusicPlayer")
@onready var video_player = get_node("/root/Control/VideoPlayer")

@onready var video_player_track = get_node("/root/Control/VideoPlayer/VideoPlayer/Player/ProgressBar")

@onready var music_player_list = get_node("/root/Control/MusicPlayer/MusicPlayer/ScrollMusic/MusicList")
@onready var music_player_track = get_node("/root/Control/MusicPlayer/MusicPlayer/ScrollMusic/MusicList/Song")

@onready var writer_app = get_node("/root/Control/Writer")
@onready var writer_text = get_node("/root/Control/Writer/Writer/TextEdit")
@onready var writer_name = get_node("/root/Control/Writer/Writer/Toolbar/Title")
@onready var writer_char = get_node("/root/Control/Writer/Writer/Infobar/CharCount")
@onready var writer_word = get_node("/root/Control/Writer/Writer/Infobar/WordCount")

@onready var game = get_node("/root/Control")

@export var local_data = {}
@export var selected_file_data = {}

var selected: bool = false
var has_cover: bool = false

var file_data

var core_folders = ["Home","Downloads","Documents","Pictures","Audio","Videos"]
var file_types = ["wdoc","png","audio","video"]

var path = "user://save_data.json"
var open_type = ""

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
	local_data = load_game()
	
	file_options.text = "File Type"
	for a in range(len(core_folders)):
		var new_core_folder = core_folder.duplicate()
		new_core_folder.show()
		new_core_folder.text = core_folders[a]
		new_core_folder.name = core_folders[a]
		if new_core_folder.text == "Home":
			new_core_folder.disabled = true
		core_folder_container.add_child.call_deferred(new_core_folder)
	for b in range(len(file_types)):
		file_options.get_popup().add_item(file_types[b])
	for c in range(len(local_data["files"])):
		if !local_data["files"][c][c].has("deleted"):
			local_data["files"][c][c]["deleted"] = false
			save(local_data)
		
		if !local_data["files"][c][c]["deleted"]:
			var new_file = mypc_file.duplicate()
			new_file.text = local_data["files"][c][c]["name"] + "." + local_data["files"][c][c]["file_type"]
			new_file.name = str(local_data["files"][c][c]["id"])
			new_file.id = local_data["files"][c][c]["id"]
			new_file.local_file_data = local_data["files"][c][c]
			new_file.show()
			if local_data["files"][c][c].has("audio_path"):
				var loaded_track = music_player_track.duplicate()
				loaded_track.id = new_file.id
				loaded_track.text = str(local_data["files"][c][c]["name"])
				loaded_track.song_path = local_data["files"][c][c]["audio_path"]
				loaded_track.name = str(local_data["files"][c][c]["id"])
				if local_data["files"][c][c].has("audio_cover"):
					loaded_track.cover_path = local_data["files"][c][c]["audio_cover"]
				loaded_track.show()
				print(loaded_track.name)
				music_player_list.add_child.call_deferred(loaded_track)
				
			var all_files = new_file.duplicate()
			match local_data["files"][c][c]["file_type"]:
				"wdoc":
					documents.add_child.call_deferred(new_file)
				"png":
					images.add_child.call_deferred(new_file)
				"audio":
					audio.add_child.call_deferred(new_file)
				"video":
					videos.add_child.call_deferred(new_file)
			files.add_child.call_deferred(new_file)
			files.add_child.call_deferred(all_files)

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

func _on_create_file_pressed():  
	create_file.show()
	file_data = {
		"name": "File",
		"file_type": "",
		"id": 0,
		"deleted": false
	}

func _on_my_pc_x_pressed():
	close_create()
	self.hide()

func close_create():
	file_options.text = "File Type"
	file_options.selected = -1
	create_file.size = Vector2(288,175)
	add_image.hide()
	open_res.hide()
	audio_button.hide()
	create_file.hide()
	create_button.disabled = false
	new_file_name.text = ""

func _on_file_x_pressed():
	close_create()

func _on_create_pressed():
	var new_file = mypc_file.duplicate()
	file_data["id"] = local_data["num_of_files"]
	file_data["name"] = str(new_file_name.text)
	match file_options.get_item_text(file_options.selected):
		"wdoc": # Adds document dictionary keys if it's a wdoc file.
			file_data["text"] = ""
			file_data["text_name"] = file_data["name"]
			file_data["char_count"] = 0
			file_data["word_count"] = 0
		"audio": # Adds a track to Music Player with the audio data stored onto it.
			var new_track = music_player_track.duplicate()
			new_track.name = str(file_data["id"])
			new_track.text = file_data["name"]
			new_track.song_path = file_data["audio_path"]
			if has_cover: # If a cover image was selected, add it to the file's dataset.
				new_track.cover_path = file_data["audio_cover"]
			new_track.show()
			music_player_list.add_child.call_deferred(new_track)
	new_file.show()
	new_file.text = str(new_file_name.text) + "." + file_options.get_item_text(file_options.selected)
	new_file.name = str(local_data["num_of_files"])
	create_file.hide()
	local_data["files"].append({int(local_data["num_of_files"]): file_data})
	local_data["num_of_files"] += 1
	new_file_name.text = ""
	save(local_data)
	local_data = load_game()
	print(local_data["files"])
	new_file.local_file_data = file_data
	var all_files = new_file.duplicate()
	
	# Adds the file into its respective folder.
	match file_data["file_type"]:
		"wdoc":
			documents.add_child.call_deferred(all_files)
		"png":
			images.add_child.call_deferred(all_files)
		"audio":
			audio.add_child.call_deferred(all_files)
		"video":
			videos.add_child.call_deferred(all_files)
	files.add_child.call_deferred(new_file)
	file_options.text = "File Type"
	file_options.selected = -1

func _on_file_options_item_selected(_index):
	cover_art.hide()
	match file_options.get_item_text(file_options.selected):
		"png":
			create_file.size = Vector2(288,230)
			add_image.show()
			open_res.show()
			create_button.disabled = true
		"audio":
			open_type = "audio"
			create_file.size = Vector2(288,284)
			audio_button.show()
			open_res.show()
			cover_art.show()
			create_button.disabled = true
		"video":
			open_type = "video"
			create_file.size = Vector2(288,230)
			open_res.show()
			create_button.disabled = true
			audio_button.show()
		_:
			create_file.size = Vector2(288,175)
			add_image.hide()
			open_res.hide()
			audio_button.hide()
			create_button.disabled = false
			
	file_data["file_type"] = str(file_options.get_item_text(file_options.selected))

func _on_choose_image_pressed():
	file_dialog.show()
	match file_options.get_item_text(file_options.selected):
		"png":
			file_dialog.title = "Open PNG"

func _on_open_res_pressed():
	var project_dir = ProjectSettings.globalize_path("user://")
	OS.shell_open(project_dir)

func _on_file_dialog_file_selected(path):
	var path_split = str(path).split(".")
	if path_split[-1] == "png":
		print("true")
		var image = Image.new()
		image.load(path)
		file_data["image"] = str(path)
		create_button.disabled = false
	elif path_split[-1] == "ogv":
		pass

func _on_open_file_pressed():
	print(selected_file_data)
	match selected_file_data["file_type"]:
		"wdoc":
			writer_app.show()
			writer_text.text = selected_file_data["text"]
			writer_name.text = selected_file_data["text_name"] + " - Pixel Writer"
			writer_char.text = "Characters - " + str(selected_file_data["char_count"])
			writer_word.text = "Words - " + str(selected_file_data["word_count"])
		"png":
			image_view.show()
		"audio":
			music_player.show()
		"video":
			video_player.show()
			var player = get_node("/root/Control/VideoPlayer/VideoPlayer/Video")
			var video = VideoStreamTheora.new()
			video.set_file(selected_file_data["video"])
			player.stream = video

func _on_choose_audio_pressed():
	audio_dialog.show()
	match open_type:
		"audio":
			audio_dialog.title = "Choose MP3"
		"video":
			audio_dialog.title = "Choose OGV"

func _on_audio_choose_file_selected(path):
	var path_split = str(path).split(".")
	print(path_split[1] == "mp3")
	match open_type:
		"audio":
			if path_split[-1] == "mp3":
				file_data["audio_path"] = str(path)
				create_button.disabled = false
		"video":
			if path_split[-1] == "ogv":
				file_data["video"] = str(path)
				create_button.disabled = false
		"cover":
			if path_split[-1] == "png":
				file_data["audio_cover"] = str(path)
				has_cover = true

func _on_my_pc_m_pressed():
	self.hide()

func _on_choose_cover_pressed():
	audio_dialog.show()
	open_type = "cover"

func _on_cancel_pressed():
	clean_warning.hide()

func _on_clean_files_pressed():
	clean_warning.show()

# Removes all files if confirmed.
func _on_confirm_pressed():
	for a in range(len(local_data["files"])):
		if local_data["files"][a][a].has("audio_path"):
			var song_path = "/root/Control/MusicPlayer/MusicPlayer/ScrollMusic/MusicList/" + str(local_data["files"][a][a]["id"])
			get_node(song_path).queue_free()
	
	local_data["files"] = []
	local_data["num_of_files"] = 0
	clean_warning.hide()
	save(local_data)

func _on_delet_file_pressed():
	var selected_id = selected_file_data["id"]
	var file_path = "/root/Control/MyPC/MyPC/ScrollFiles/Files/" + str(selected_id)
	local_data["files"][selected_id][selected_id]["deleted"] = true
	image_preview.hide()
	get_node(file_path).hide()
	save(local_data)
