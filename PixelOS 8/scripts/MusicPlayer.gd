extends Control

@onready var track = get_node("/root/Control/Music")
@onready var song = get_node("/root/Control/MusicPlayer/MusicPlayer/MusicList/Song")
@onready var song_list = get_node("/root/Control/MusicPlayer/MusicPlayer/MusicList")
@onready var track_timer = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/ValueIncrease")
@onready var track_progress = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar")
@onready var dragger = $MusicPlayer/Toolbar/Dragger
@onready var song_time = $MusicPlayer/Player/ProgressBar/LengthTime
@onready var audio_name = $MusicPlayer/Player/AudioName
@onready var pause = $MusicPlayer/Player/Pause

@export var current_song = ""
@export var song_name = ""
@export var song_id: int = 0
@export var local_data = {}

var selected: bool = false
var open: bool = false

var audio_files = []
var path = "user://save_data.json"

func _on_play_pressed():
	track.play()
	track_timer.start()

# If progress bar reaches the end, the bar will reset back to 0.
var song_path = "/root/Control/MusicPlayer/MusicPlayer/MusicList/"
func _on_value_increase_timeout():
#	var song = get_node(song_path + str(song_id))
	track_progress.value += 1
#	song.secconds -= 1
#	if song.secconds == 0:
#		song.minutes -= 1
#		song.secconds = 59
#		if song.minutes == 0:
#			song.hours -= 1
#			song.minutes = 59
#	song_time.text = str(song.hours) + ":" + str(song.minutes) + ":" + str(song.secconds)
	
	if track_progress.value == track_progress.max_value:
		track_timer.stop()
		track_progress = 0

func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	local_data = load_game()

func _on_music_x_pressed():
	track.stop()
	track_timer.stop()
	track_progress.value = 0
	song_time.text = "0:00"
	audio_name.text = "No Audio Selected."
	self.hide()

func _on_end_pressed():
	track_progress.value = 0
	track_timer.stop()
	track.play()
	track_timer.start()

# This _process() function is how you can drag the window.
var mouse_offset = get_global_mouse_position()
func _process(_delta): # Called every frame.
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false
	
	if Input.is_action_just_pressed("space_bar"):
		if open:
			track.stream_paused = !track.stream_paused

func _on_play_visibility_changed():
	open = self.visible

func _on_music_m_pressed():
	self.hide()

func _on_pause_pressed():
	track.stream_paused = !track.stream_paused
	if track.stream_paused == true:
		pause.text = "Resume"
	else:
		pause.text = "Pause"