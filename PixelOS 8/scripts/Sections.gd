extends Button

@onready var system_tab = get_node("/root/Control/Settings/Settings/System")
@onready var person_tab = get_node("/root/Control/Settings/Settings/Personalize")
@onready var world_tab = get_node("/root/Control/Settings/Settings/WorldBuilding")
@onready var about_tab = get_node("/root/Control/Settings/Settings/About")
@onready var apply_button = get_node("/root/Control/Settings/Settings/Apply")
@onready var apply_warning = get_node("/root/Control/Settings/Settings/ApplyWarning")

# Called when the node enters the scene tree for the first time.
func _pressed():
	match self.text:
		"System":
			system_tab.show()
			person_tab.hide()
			world_tab.hide()
			about_tab.hide()
			apply_button.show()
			apply_warning.show()
		"Personalization":
			system_tab.hide()
			person_tab.show()
			world_tab.hide()
			about_tab.hide()
			apply_button.show()
			apply_warning.show()
		"World Building":
			system_tab.hide()
			person_tab.hide()
			about_tab.hide()
			world_tab.show()
			apply_button.show()
			apply_warning.show()
		"About":
			system_tab.hide()
			person_tab.hide()
			world_tab.hide()
			about_tab.show()
			apply_button.hide()
			apply_warning.hide()
