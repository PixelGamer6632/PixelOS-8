extends Button

@onready var browser = get_node("/root/Control/Browser")

@export var id: int = 0

# Called when the node is pressed.
func _pressed():
	#var id2 = self.name
	browser.selected_tab = int(id)
	
	for a in range(3):
		var path = "/root/Control/Browser/Browser/Websites/" + str(a)
		get_node(path).hide()
	var path = "/root/Control/Browser/Browser/Websites/" + str(browser.browser_data[id]["site_id"])
	get_node(path).show()
	for b in range(len(browser.browser_data)):
		var tab_path = "/root/Control/Browser/Browser/Toolbar/Tabs/"
		get_node(tab_path + str(b)).disabled = false
	self.disabled = true
