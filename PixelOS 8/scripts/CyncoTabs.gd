extends Button

@onready var cynco_home = get_node("/root/Control/Browser/Browser/Websites/2/Homepage")
@onready var cynco_download = get_node("/root/Control/Browser/Browser/Websites/2/DownloadCyndows")
@onready var cynco_display = get_node("/root/Control/Browser/Browser/Websites/2/Homepage/Panel2")
@onready var cynco_caltana = get_node("/root/Control/Browser/Browser/Websites/2/Caltana")

@onready var pixelos_button = get_node("/root/Control/Browser/Browser/Websites/1/Button")
@onready var cynco_button = get_node("/root/Control/Browser/Browser/Websites/1/CyncoSite")

func set_picture(image):
	var new_texture = StyleBoxTexture.new()
	new_texture.texture = image
	cynco_display.add_theme_stylebox_override("panel",new_texture)

# Called when the node enters the scene tree for the first time.
func _pressed():
	pixelos_button.disabled = false
	cynco_button.disabled = false
	cynco_home.show()
	cynco_download.hide()
	match self.text:
		"CYNDOWS":
			cynco_home.hide()
			cynco_download.show()
			cynco_caltana.hide()
		"CYN-PAD":
			set_picture(load("res://assets/images/CynPads.jpg"))
			cynco_home.show()
			cynco_download.hide()
			cynco_caltana.hide()
		"THINK-TV":
			set_picture(load("res://assets/images/CBM ThinkTV.jpg"))
			cynco_home.show()
			cynco_download.hide()
			cynco_caltana.hide()
		"CYN-PC":
			cynco_home.show()
			cynco_download.hide()
			set_picture(load("res://assets/images/CynPCs.jpg"))
		"CALTANA":
			cynco_home.hide()
			cynco_download.hide()
			cynco_caltana.show()
