extends Button

@onready var display = get_node("/root/Control/Calculator/Calculator/NumDisplay/Label")

var symbol = self.text

# Called when the node is pressed.
func _pressed():
	if self.text != "=" and self.text != "C":
		if display.text == "0":
			display.text = ""
		display.text += str(self.text)
		if self.text == "+" or self.text == "-" or self.text == "x" or self.text == "∻":
			symbol = str(self.text)
	else:
		if self.text == "=" and self.text != "C":
			for a in range(len(display.text)):
				if display.text[a] == "+" or display.text[a] == "-" or display.text[a] == "x" or display.text[a] == "∻":
					symbol = display.text[a]
			var split_equasion = display.text.split(symbol)
			var finalized_sum
			if symbol == "+" or symbol == "-" or symbol == "x" or symbol == "∻":
				match symbol:
					"+":
						finalized_sum = int(split_equasion[0]) + int(split_equasion[1])
						display.text = str(finalized_sum)
					"-":
						finalized_sum = int(split_equasion[0]) - int(split_equasion[1])
						display.text = str(finalized_sum)
					"x":
						finalized_sum = int(split_equasion[0]) * int(split_equasion[1])
						display.text = str(finalized_sum)
					"∻":
						finalized_sum = int(split_equasion[0]) / int(split_equasion[1])
						display.text = str(finalized_sum)
				print("done")
		elif self.text == "C":
			display.text = "0"
