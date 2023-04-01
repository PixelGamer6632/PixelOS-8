extends Button

@onready var system_tab = get_node("/root/Control/Settings/Settings/System")
@onready var person_tab = get_node("/root/Control/Settings/Settings/Personalize")
@onready var world_tab = get_node("/root/Control/Settings/Settings/WorldBuilding")
@onready var about_tab = get_node("/root/Control/Settings/Settings/About")
@onready var apply_button = get_node("/root/Control/Settings/Settings/Apply")
@onready var apply_warning = get_node("/root/Control/Settings/Settings/ApplyWarning")

var tabs = ["System","Personalize","WorldBuilding","About"]

func close_all_tabs():
	for a in range(len(tabs)):
		var tab_path = "/root/Control/Settings/Settings/" + tabs[a]
		var section_path = "/root/Control/Settings/Settings/Categories/" + str(a)
		get_node(tab_path).hide()
		get_node(section_path).disabled = false

# Called when the node enters the scene tree for the first time.
func _pressed():
	match self.text:
		"System":
			close_all_tabs()
			system_tab.show()
			apply_button.show()
			apply_warning.show()
		"Personalization":
			close_all_tabs()
			person_tab.show()
			apply_button.show()
			apply_warning.show()
		"World Building":
			close_all_tabs()
			world_tab.show()
			apply_button.show()
			apply_warning.show()
		"About":
			close_all_tabs()
			about_tab.show()
			apply_button.hide()
			apply_warning.hide()
	self.disabled = true
