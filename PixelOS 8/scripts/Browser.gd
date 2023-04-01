extends Control

@onready var tab = get_node("/root/Control/Browser/Browser/Toolbar/Tabs/Tab")
@onready var tab_container = get_node("/root/Control/Browser/Browser/Toolbar/Tabs")

@onready var dragger = $Browser/Toolbar/Dragger

@onready var pixelos_tab = get_node("/root/Control/Browser/Browser/Websites/0/Panel/HBoxContainer/Pxlos3")#$Browser/Websites/0/Panel/HBoxContainer/Pxlos3
@onready var pixelos_tab_container = get_node("/root/Control/Browser/Browser/Websites/0/Panel/HBoxContainer")

@export var selected_tab = 0

var num_of_tabs: int = 0
var open_site: int = 0

var selected: bool = false

var browser_data = []

var site_names = ["PixelOS - Official Site","Home"]

func create_tab():
	for a in range(2):
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
	tab_container.add_child.call_deferred(new_tab)
	
	browser_data.append({ # Each tab has its own dataset. Site ID is the website that was loaded onto the tab.
		"site_id": 1,
		"tab_id": num_of_tabs
	})
	num_of_tabs += 1
	selected_tab = num_of_tabs

func load_site(site_name):
	
	#if !tab_path2.has_node("0"):
	#	create_tab()
	for a in range(2):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	var site_path = "/root/Control/Browser/Browser/Websites/" + str(site_name)
	var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/" + str(browser_data[selected_tab]["tab_id"])
	get_node(site_path).show()
	get_node(tab_path).text = str(site_names[site_name])
	browser_data[selected_tab]["site_id"] = site_name

# Called when the node enters the scene tree for the first time.
func _ready():
	create_tab()
	selected_tab = 0
	# This for loop generates the tabs for the PixelOS website, not the browser tabs.
	for a in range(7):
		var new_tab = pixelos_tab.duplicate()
		new_tab.text = "PIXELOS " + str(a+1)
		new_tab.show()
		pixelos_tab_container.add_child.call_deferred(new_tab)

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
	browser_data = []
	self.hide()

func _on_new_tab_pressed():
	create_tab()

func _on_button_pressed():
	load_site(0)

func _on_close_tab_pressed():
	var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/"
	var site_path = "/root/Control/Browser/Browser/Websites/"
	get_node(site_path + str(browser_data[selected_tab]["site_id"])).hide()
	get_node(tab_path + str(browser_data[selected_tab]["tab_id"])).hide()
	for a in range(2):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	get_node("/root/Control/Browser/Browser/Websites/1").show()
	print(browser_data)

func _on_browser_m_pressed():
	self.hide()
