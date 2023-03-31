extends Button

@onready var music_player = get_node("/root/Control/MusicPlayer")
@onready var player_menu = get_node("/root/Control/MusicPlayer/MusicPlayer/Player")
@onready var track_progress = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar")
@onready var track_time = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/ValueIncrease")
@onready var load_error = get_node("/root/Control/ImageError")
@onready var cover_display = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/CoverDisplay")
@onready var audio_name = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/AudioName")
@onready var time_length = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/LengthTime")

@export var id = 0
@export var local_data = {}
@export var song_path = ""
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

# Called when the node is pressed.
# Creates an audio file, preloads the mp3 file from user:// to the audio file, then applies it to the AudioStreamPlayer2D node.
func _pressed():
	if FileAccess.file_exists(song_path):
		secconds = 0
		minutes = 0
		hours = 0
		audio_name.text = self.text
		track_progress.value = 0
		track_time.stop()
		var player = get_node("/root/Control/Music")
		var newstream = AudioStreamMP3.new()
		var file = FileAccess.open(song_path,FileAccess.READ)
		
		newstream.data = file.get_buffer(file.get_length())
		#var cover = newstream.get_data()
		player.stream = newstream
		track_progress.max_value = player.stream.get_length()
		#if cover.size() > 0:
		#	
		#	var tag_lib = Tag
		#	
		#	var image = Image.new()
		#	
		#	#image.save_png(str(cover))
		#	image.create_from_data(cover)
		#	
		#	var texture = ImageTexture.new()
		#	texture.create_from_image(image)
		#	var preview_tex = StyleBoxTexture.new()
		#	
		#	preview_tex.texture = texture
		#	cover_display.add_theme_stylebox_override("panel",preview_tex)
		
		#print(song_path)
		
		for a in range(player.stream.get_length()):
			secconds += 1
			if secconds == 60:
				secconds = 0
				minutes += 1
				if minutes == 60:
					minutes = 0
					hours += 1
		if hours == 0:
			time_length.text = str(minutes) + ":" + str(secconds)
		elif minutes == 0:
			time_length.text = str(secconds)
		else:
			time_length.text = str(hours) + ":" + str(minutes) + ":" + str(secconds)
		music_player.song_id = id
	else:
		load_error.show()
