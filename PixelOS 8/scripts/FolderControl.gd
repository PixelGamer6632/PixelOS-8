extends Button

@onready var home = get_node("/root/Control/MyPC/MyPC/ScrollFiles")
@onready var documents = get_node("/root/Control/MyPC/MyPC/ScrollFilesDocuments")
@onready var images = get_node("/root/Control/MyPC/MyPC/ScrollFilesImages")
@onready var audio = get_node("/root/Control/MyPC/MyPC/ScrollFilesAudio")
@onready var videos = get_node("/root/Control/MyPC/MyPC/ScrollFilesVideos")

var folders = [
	"/root/Control/MyPC/MyPC/ScrollFiles",
	"/root/Control/MyPC/MyPC/ScrollFilesDocuments",
	"/root/Control/MyPC/MyPC/ScrollFilesImages",
	"/root/Control/MyPC/MyPC/ScrollFilesAudio",
	"/root/Control/MyPC/MyPC/ScrollFilesVideos"
	]
	
var core_folders = ["Home","Downloads","Documents","Pictures","Audio","Videos"]

func hide_all_folders():
	for a in range(len(folders)):
		get_node(folders[a]).hide()
	
func switch_tabs(folder):
	var folder_path = "/root/Control/MyPC/MyPC/Folders/"
	for a in range(len(core_folders)):
		get_node(folder_path + core_folders[a]).disabled = false
	get_node(folder_path + folder).disabled = true

# Called when the node enters the scene tree for the first time.
func _pressed():
	match self.text:
		"Home":
			hide_all_folders()
			switch_tabs(core_folders[0])
			home.show()
		"Downloads":
			switch_tabs(core_folders[1])
		"Documents":
			hide_all_folders()
			switch_tabs(core_folders[2])
			documents.show()
		"Pictures":
			hide_all_folders()
			switch_tabs(core_folders[3])
			images.show()
		"Audio":
			hide_all_folders()
			switch_tabs(core_folders[4])
			audio.show()
		"Videos":
			hide_all_folders()
			switch_tabs(core_folders[5])
			videos.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
