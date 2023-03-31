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

func hide_all_folders():
	for a in range(len(folders)):
		get_node(folders[a]).hide()

# Called when the node enters the scene tree for the first time.
func _pressed():
	match self.text:
		"Home":
			hide_all_folders()
			home.show()
		"Documents":
			hide_all_folders()
			documents.show()
		"Pictures":
			hide_all_folders()
			images.show()
		"Audio":
			hide_all_folders()
			audio.show()
		"Videos":
			hide_all_folders()
			videos.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
