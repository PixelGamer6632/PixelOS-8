extends Control

@onready var tab = get_node("/root/Control/Browser/Browser/Toolbar/Tabs/Tab")
@onready var tab_container = get_node("/root/Control/Browser/Browser/Toolbar/Tabs")

@onready var dragger = $Browser/Toolbar/Dragger
@onready var download_progress = $Browser/DownloadProgress
@onready var download_progress_timer = $Browser/DownloadProgress/DownloadTimer
@onready var download_failed = $Browser/DownloadFailed
@onready var failed_timer = $Browser/DownloadFailed/Timer

@onready var pixelos_tab = get_node("/root/Control/Browser/Browser/Websites/0/Panel/HBoxContainer/Pxlos3")#$Browser/Websites/0/Panel/HBoxContainer/Pxlos3
@onready var pixelos_tab_container = get_node("/root/Control/Browser/Browser/Websites/0/Panel/HBoxContainer")

@onready var cynco_tab = get_node("/root/Control/Browser/Browser/Websites/2/Panel/HBoxContainer/Tab")
@onready var cynco_tab_container = get_node("/root/Control/Browser/Browser/Websites/2/Panel/HBoxContainer")
@onready var cynco_prompt = get_node("/root/Control/Browser/Browser/Websites/2/Caltana/HBoxContainer/Prompt")
@onready var cynco_prompt_container = get_node("/root/Control/Browser/Browser/Websites/2/Caltana/HBoxContainer")

@onready var pixelos_button = get_node("/root/Control/Browser/Browser/Websites/1/Button")
@onready var cynco_button = get_node("/root/Control/Browser/Browser/Websites/1/CyncoSite")

@export var selected_tab = 0
@export var caltana_replies: int = 0

var num_of_tabs: int = 0
var open_site: int = 0


var selected: bool = false

var browser_data = []

var site_names = ["PixelOS - Official Site","Home","Cynco - Building Your Tomarow"]

var cynco_tabs = ["CYN-PC","THINK-TV","CYN-PHONE","CYN-PAD","CYNDOWS","CALTANA"]
@export var caltana_prompts = [
	"What's the weather?",
	"Do you love Cynco?",
	"What's the time?",
	"How do I fix my Cyn-device?",
	"Where do I buy an AC unit?"
	]

func create_tab():
	pixelos_button.disabled = true
	cynco_button.disabled = true
	for a in range(3):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	get_node("/root/Control/Browser/Browser/Websites/1").show()
	
	var new_tab = tab.duplicate()
	new_tab.show()
	new_tab.text = "New Tab"
	new_tab.id = num_of_tabs
	new_tab.name = str(num_of_tabs)
	if new_tab.id == 0:
		new_tab.disabled = true
		pixelos_button.disabled = false
		cynco_button.disabled = false
	tab_container.add_child.call_deferred(new_tab)
	
	browser_data.append({ # Each tab has its own dataset. Site ID is the website that was loaded onto the tab.
		"site_id": 1,
		"tab_id": num_of_tabs
	})
	num_of_tabs += 1
	print("done lol")

func load_site(site_name):
	print(browser_data[selected_tab]["site_id"])
	#if !tab_path2.has_node("0"):
	#	create_tab()
	for a in range(3):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	var site_path = "/root/Control/Browser/Browser/Websites/" + str(site_name)
	var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/" + str(browser_data[selected_tab]["tab_id"])
	get_node(site_path).show()
	get_node(tab_path).text = str(site_names[site_name])
	browser_data[selected_tab]["site_id"] = site_name
#	print(browser_data[selected_tab]["site_id"])

# Called when the node enters the scene tree for the first time.
func _ready():
	create_tab()
	pixelos_button.disabled = false
	cynco_button.disabled = false
	selected_tab = 0
	print(browser_data)
	# This for loop generates the tabs for the PixelOS website, not the browser tabs.
	for a in range(7):
		var new_tab = pixelos_tab.duplicate()
		new_tab.text = "PIXELOS " + str(a+1)
		new_tab.show()
		pixelos_tab_container.add_child.call_deferred(new_tab)
	for b in range(len(cynco_tabs)):
		var new_cyn_tab = cynco_tab.duplicate()
		new_cyn_tab.text = cynco_tabs[b]
		new_cyn_tab.show()
		cynco_tab_container.add_child.call_deferred(new_cyn_tab)
	for c in range(len(caltana_prompts)):
		var new_prompt = cynco_prompt.duplicate()
		new_prompt.text = caltana_prompts[c]
		new_prompt.name = str(c)
		new_prompt.show()
		cynco_prompt_container.add_child.call_deferred(new_prompt)

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

func _on_browser_x_pressed():
	var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/"
	for a in range(len(browser_data)):
		get_node(tab_path + str(a)).queue_free()
	for b in range(3):
		var path = "/root/Control/Browser/Browser/Websites/" + str(b)
		get_node(path).hide()
	get_node("/root/Control/Browser/Browser/Websites/1").show()
	get_node("/root/Control/Browser/Browser/Websites/1/Button").disabled = false
	get_node("/root/Control/Browser/Browser/Websites/1/CyncoSite").disabled = false
	browser_data = []
	num_of_tabs = 0
	selected_tab = 0
	pixelos_button.disabled = false 
	cynco_button.disabled = false
	clear_caltana_replies()
	create_tab()
	if get_node("/root/Control/Browser/Browser/Toolbar/Tabs").has_node("0"):
		get_node("/root/Control/Browser/Browser/Toolbar/Tabs/0").name = "t0"
		print(get_node("/root/Control/Browser/Browser/Toolbar/Tabs/" + str(browser_data[selected_tab]["tab_id"])))
		print("ok")
	self.hide()
	print(browser_data)

func _on_new_tab_pressed():
	create_tab()

func _on_button_pressed():
	load_site(0)

func _on_close_tab_pressed():
	var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/"
	var site_path = "/root/Control/Browser/Browser/Websites/"
	get_node(site_path + str(browser_data[selected_tab]["site_id"])).hide()
	get_node(tab_path + str(browser_data[selected_tab]["tab_id"])).hide()
	for a in range(3):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	get_node("/root/Control/Browser/Browser/Websites/1").show()
	print(browser_data)

func _on_browser_m_pressed():
	self.hide()

func _on_cynco_site_pressed():
	load_site(2)

func _on_download_pressed():
	download_progress.show()
	download_progress.max_value = 300
	download_progress_timer.start()

func _on_download_timer_timeout():
	download_progress.value += 1
	if download_progress.value == download_progress.max_value:
		download_progress_timer.stop()
		download_progress.hide()
		download_failed.show()

func _on_download_failed_visibility_changed():
	if download_failed.visible == true:
		failed_timer.start()

func _on_failed_timer_timeout():
	download_failed.hide()

func clear_caltana_replies():
	for a in range(caltana_replies):
		var reply_path = "/root/Control/Browser/Browser/Websites/2/Caltana/Responses/VBoxContainer/" + str(a)
		print(a)
		get_node(reply_path).queue_free()
	caltana_replies = 0

func _on_clear_responses_pressed():
	clear_caltana_replies()
