extends Button

@onready var track = get_node("/root/Control/Music")
@onready var music_player = get_node("/root/Control/MusicPlayer")
@onready var player_menu = get_node("/root/Control/MusicPlayer/MusicPlayer/Player")
@onready var track_progress = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar")
@onready var track_time = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/ValueIncrease")
@onready var load_error = get_node("/root/Control/ImageError")
@onready var cover_display = get_node("/root/Control/MusicPlayer/MusicPlayer/CoverDisplay")
@onready var audio_name = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/AudioName")
@onready var time_length = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/LengthTime")
@onready var play = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/Play")
@onready var widget_progress = get_node("/root/Control/Widgets/Widget/ProgressBar")
@onready var widget_play = get_node("/root/Control/Widgets/Widget/Play")
@onready var widget_label = get_node("/root/Control/Widgets/Widget/Label")
@onready var pause = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/Pause")
@onready var title = get_node("/root/Control/MusicPlayer/MusicPlayer/Toolbar/Title")

@export var id = 0
@export var local_data = {}
@export var song_path = ""
@export var cover_path = ""
@export var secconds: int = 0
@export var minutes: int = 0
@export var hours: int = 0

var path = "user://save_data.json"

func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	local_data = load_game()
	print(cover_path)

# Called when the node is pressed.
# Creates an audio file, preloads the mp3 file from user:// to the audio file, then applies it to the AudioStreamPlayer2D node.
func _pressed():
	if FileAccess.file_exists(song_path):
		secconds = 0
		minutes = 0
		hours = 0
		audio_name.text = self.text
		widget_label.text = self.text
		title.text = self.text + " - Music Player"
		track_progress.value = 0
		widget_progress.value = 0
		track_time.stop()
		var player = get_node("/root/Control/Music")
		var newstream = AudioStreamMP3.new()
		var file = FileAccess.open(song_path,FileAccess.READ)
		
		newstream.data = file.get_buffer(file.get_length())
		#var cover = newstream.get_data()
		player.stream = newstream
		track_progress.max_value = player.stream.get_length()
		music_player.song_length = player.stream.get_length()
		
		cover_display.show()
		var stylebox = StyleBoxTexture.new()
		if cover_path != "":
			var image = Image.new()
			var photo = FileAccess.open(cover_path,FileAccess.READ)
			var buffer = photo.get_buffer(photo.get_length())
			image.load_png_from_buffer(buffer)
			var texture = ImageTexture.create_from_image(image)
			stylebox.texture = texture
			cover_display.add_theme_stylebox_override("panel",stylebox)
		else:
			var image = ResourceLoader.load("res://assets/images/Screenshot 2022-04-15 221151.png")
			var texture = ImageTexture.create_from_image(image)
			stylebox.texture = load("res://assets/images/Screenshot 2022-04-15 221151.png")
			cover_display.add_theme_stylebox_override("panel",stylebox)
		
		for a in range(player.stream.get_length()):
			secconds += 1
			if secconds == 60:
				secconds = 0
				minutes += 1
				if minutes == 60:
					minutes = 0
					hours += 1
		if hours == 0:
			time_length.text = "0:00 / " + str(minutes) + ":" + str(secconds)
			music_player.song_string_time = str(minutes) + ":" + str(secconds)
		elif minutes == 0:
			time_length.text = "0:00 / " + str(secconds)
			music_player.song_string_time = str(secconds)
		else:
			time_length.text = "0:00 / " + str(hours) + ":" + str(minutes) + ":" + str(secconds)
			music_player.song_string_time = str(hours) + ":" + str(minutes) + ":" + str(secconds)
		music_player.song_id = id
		play.disabled = false
		widget_play.disabled = false
		pause.text = "Pause"
		track.stream_paused = false
	else:
		load_error.show()
