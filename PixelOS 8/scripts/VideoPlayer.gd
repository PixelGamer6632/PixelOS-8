extends Control

@onready var video = $VideoPlayer/Video
@onready var video_progress = $VideoPlayer/Player/ProgressBar
@onready var video_progress_timer = $VideoPlayer/Player/ProgressBar/ValueIncrease
@onready var dragger = $VideoPlayer/Toolbar/Dragger
@onready var pause = $VideoPlayer/Player/Pause
@onready var play = $VideoPlayer/Player/Play

var selected: bool = false
var open: bool = false
var playing = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
var mouse_offset = get_global_mouse_position()
func _process(_delta):
	if selected:
		self.position = get_global_mouse_position() + mouse_offset
	if dragger.button_pressed == true:
		mouse_offset = position - get_global_mouse_position()
		selected = true
	else:
		selected = false

func _input(_event):
	if Input.is_action_just_pressed("space_bar"):
		if open:
			video.paused = !video.paused

func play_video():
	video.play()
	video_progress_timer.start()
	playing = true
	play.disabled = true

func _on_play_pressed():
	play_video()

func _on_value_increase_timeout():
	video_progress.value += 1
	if video_progress.value == video_progress.max_value:
		video_progress_timer.stop()

func _on_music_m_pressed():
	self.hide()

func _on_video_x_pressed():
	video.stop()
	video_progress_timer.stop()
	video_progress.value = 0
	video.paused = false
	pause.text = "Pause"
	play.disabled = false
	self.hide()

func _on_visibility_changed():
	open = self.visible

func _on_pause_pressed():
	video.paused = !video.paused
	if video.paused == true:
		pause.text = "Resume"
	else:
		pause.text = "Pause"

func _on_replay_pressed():
	video_progress.value = 0
	video.paused = false
	pause.text = "Pause"
	play_video()
