extends Control

@onready var track = get_node("/root/Control/Music")
@onready var music_player = get_node("/root/Control/MusicPlayer")
@onready var song = get_node("/root/Control/MusicPlayer/MusicPlayer/MusicList/Song")
@onready var song_list = get_node("/root/Control/MusicPlayer/MusicPlayer/MusicList")
@onready var song_list_scroll = get_node("/root/Control/MusicPlayer/MusicPlayer/ScrollMusic")
@onready var track_timer = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/ValueIncrease")
@onready var track_progress = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar")
@onready var widget_progress = get_node("/root/Control/Widgets/Widget/ProgressBar")
@onready var dragger = get_node("/root/Control/MusicPlayer/MusicPlayer/Toolbar/Dragger")
@onready var song_time = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/ProgressBar/LengthTime")
@onready var audio_name = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/AudioName")
@onready var pause = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/Pause")
@onready var play = get_node("/root/Control/MusicPlayer/MusicPlayer/Player/Play")
@onready var widget_pause = get_node("/root/Control/Widgets/Widget/Pause")
@onready var widget_play = get_node("/root/Control/Widgets/Widget/Play")
@onready var widget = get_node("/root/Control/Widgets/Widget")
@onready var widgets = get_node("/root/Control/Widgets")
@onready var cover_display = get_node("/root/Control/MusicPlayer/MusicPlayer/CoverDisplay")
#@onready var expand = get_node("/root/Control/MusicPlayer/MusicPlayer/FullscreenCover")

@export var current_song = ""
@export var song_name = ""
@export var song_string_time = ""
@export var song_id: int = 0
@export var song_length: int = 0
@export var local_data = {}

var song_pos_secconds = 0
var song_pos_minutes: int = 0
var song_pos_hours: int = 0

var selected: bool = false
var open: bool = false
var autoplay: bool = false
var fullscreen: bool = false

var audio_files = []
var path = "user://save_data.json"

func _on_play_pressed():
	widget.show()
	song_pos_secconds = 0
	song_pos_minutes = 0
	song_pos_hours = 0
	track.play()
	track_timer.start()
	play.disabled = true
	widget_play.disabled = true
	widget_progress.max_value = song_length

# If progress bar reaches the end, the bar will reset back to 0.
var song_path = "/root/Control/MusicPlayer/MusicPlayer/MusicList/"
func _on_value_increase_timeout():
	var song_string = ""
#	var song = get_node(song_path + str(song_id))
	track_progress.value += 1
	widget_progress.value += 1
	song_pos_secconds += 1
	if song_pos_secconds == 60:
		song_pos_minutes += 1
		song_pos_secconds = 0
		if song_pos_minutes == 60:
			song_pos_hours += 1
			song_pos_minutes = 0
	if song_pos_secconds < 10:
		song_string = "0" + str(song_pos_secconds)
	else:
		song_string = song_pos_secconds
	print(song_string_time)
	if song_pos_hours > 0:
		song_time.text = str(song_pos_hours) + ":" + str(song_pos_minutes) + ":" + str(song_string) + " / " + song_string_time
	else:
		song_time.text = str(song_pos_minutes) + ":" + str(song_string) + " / " + song_string_time
	song_string = ""
	
	if track_progress.value == track_progress.max_value:
		track_timer.stop()
		track_progress.value = 0
		play.disabled = false
		widget_play.disabled = false
		if autoplay == true:
			replay()

func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	local_data = load_game()
	widget_pos = widgets.position.x

func replay():
	play.disabled = true
	widget_play.disabled = true
	track_progress.value = 0
	widget_progress.value = 0
	track_timer.stop()
	track.play()
	track_timer.start()
	song_pos_secconds = 0
	song_pos_minutes = 0
	song_pos_hours = 0

func _on_music_x_pressed():
	track.stop()
	track_timer.stop()
	track_progress.value = 0
	song_time.text = "0:00"
	audio_name.text = "No Audio Selected."
	song_pos_secconds = 0
	song_pos_minutes = 0
	song_pos_hours = 0
	play.disabled = false
	widget.hide()
	self.hide()

func _on_end_pressed():
	play.disabled = true
	replay()

# This _process() function is how you can drag the window.
var widget_pos
var mouse_offset = get_global_mouse_position()
func _process(_delta): # Called every frame.
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
		widgets.position = Vector2(widget_pos,120)
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
		track_timer.stop()
		pause.text = "Resume"
		widget_pause.text = "Resume"
	else:
		pause.text = "Pause"
		widget_pause.text = "Pause"
		track_timer.start()

func _on_autoplay_toggled(button_pressed):
	autoplay = button_pressed

func _on_fullscreen_cover_pressed():
	fullscreen = !fullscreen
	if fullscreen == false:
		cover_display.size = Vector2(409,409)
		cover_display.position = Vector2(76,105)
		song_list_scroll.size = Vector2(493,480)
		song_list_scroll.position = Vector2(568,67)
	else:
		cover_display.size = Vector2(181,181)
		cover_display.position = Vector2(15,363)
		song_list_scroll.size = Vector2(1036,480)
		song_list_scroll.position = Vector2(21,67)
