extends Control

@onready var sidebar_button = $Panel/VBoxContainer/Menu
@onready var pixel_container = $Panel/VBoxContainer

var side_bar_apps = {
	0: {
		"name": "Settings",
		"icon": "res://assets/icons/SettingsSideBar.svg"
	},
	1: {
		"name": "myPC",
		"icon": "res://assets/icons/MyPC2.svg"
	},
	2: {
		"name": "Pixel_Store",
		"icon": "res://assets/icons/StoreSideBar.svg"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in range(len(side_bar_apps)):
		var new_app = sidebar_button.duplicate()
		new_app.show()
		new_app.icon = load(side_bar_apps[a]["icon"])
		new_app.name = side_bar_apps[a]["name"]
		pixel_container.add_child.call_deferred(new_app)
