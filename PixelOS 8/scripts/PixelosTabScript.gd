extends Button

# Script for the PixelOS website.

@onready var screenshot_display = get_node("/root/Control/Browser/Browser/Websites/0/InfoPage/ScrollContainer/Control/PixelOSDisplay")
@onready var screenshot_desc = get_node("/root/Control/Browser/Browser/Websites/0/InfoPage/ScrollContainer/Control/Description")
@onready var screenshot_name = get_node("/root/Control/Browser/Browser/Websites/0/InfoPage/ScrollContainer/Control/Name")

var pixelos_1 = load("res://assets/pixelos_screenshots/PixelOS1.png")
var pixelos_3 = load("res://assets/pixelos_screenshots/PixelOS3.png")
var pixelos_4 = load("res://assets/pixelos_screenshots/PixelOS4.png")
var pixelos_5 = load("res://assets/pixelos_screenshots/PixelOS5.png")
var pixelos_6 = load("res://assets/pixelos_screenshots/PixelOS6.png")

var descriptions = [
	"PixelOS 1 was created sometime in December 2020. It was on a Minecraft computer build and was very basic. The music app could only play a song of 4 note blocks.",
	"PixelOS 3 was released on January 13, 2021. It was the first version to come to Scratch. It was also fairly basic with not much to do then click some buttons.",
	"PixelOS 4 was originally called MaleniaOS 4 and was released on July 26, 2021. The version has since been almost lost to time and this is the only photo of it's existance.",
	"PixelOS 5 was released on August 29, 2021. This version rebranded back to PixelOS along with some new anamations. There isnt much to say as the update was fairly small.",
	"PixelOS 6 was a total overhaul and didnt release until December 11, 2021. Nearly everything was updated. Including better anamations, on top of 34 other major changes. This was when PixelOffice was born. PixelOS SE (scratch edition) was discontinued January 2023 after 2 years of updates.",
	"PixelOS 7 leaves Scratch for Godot engine. It was a lot more cabable then PixelOS SE. It released on July 15, 2022. It was very reminicant off of macOS. However, as my GDScript knowledge got better, the game felt more messy, a PixelOS 8 prototype update was too complicated and it was discontinued in January 2023. The New PixelOS 8 rewrite would begin development in Febuary and ramped up in March."
]

func set_picture(image):
	var new_texture = StyleBoxTexture.new()
	new_texture.texture = image
	screenshot_display.add_theme_stylebox_override("panel",new_texture)

# Called when the node is pressed.
func _pressed():
	match self.text:
		"PIXELOS 1":
			set_picture(pixelos_1)
			screenshot_desc.text = descriptions[0]
		"PIXELOS 3":
			set_picture(pixelos_3)
			screenshot_desc.text = descriptions[1]
		"PIXELOS 4":
			set_picture(pixelos_4)
			screenshot_desc.text = descriptions[2]
		"PIXELOS 5":
			set_picture(pixelos_5)
			screenshot_desc.text = descriptions[3]
		"PIXELOS 6":
			set_picture(pixelos_6)
			screenshot_desc.text = descriptions[4]
