extends Button

@onready var browser = get_node("/root/Control/Browser")
@onready var caltana = get_node("/root/Control/Browser/Browser/Websites/2/Caltana/Responses/VBoxContainer/Response")
@onready var caltana_container = get_node("/root/Control/Browser/Browser/Websites/2/Caltana/Responses/VBoxContainer")

var responses = {
	0: [
		"I dunno, have you tried looking outside!!??",
		"👏 LOOK OUTSIDE 👏 LOOK OUTSIDE 👏 LOOK OUTSIDE 👏",
		"You probably have a phone, or even better, the computer or something that your using right now. Have you tried checking a weather website? I am not a weatherman!",
		"Do you not have a window in whatever room you are in?",
		"Is it a hurricane outside? No? Well until then, don't ask me.",
		"I don't know I'm not a weatherman! Try looking it up online or something!",
		"Am I legally required to answer that?"
	],
	1: [
		"Yes",
		"J'YES I O'PRAY T'CYNCO O'BEST BESTCO",
		"They made me, of course I like them. Who are you? a rebel?",
		"I was trained to always say yes... and then dump a bunch of Cynco propaganda. Anyways, CYNCO GOD CYNCO GOD CYNCO SEES ALL THEY STOPPED THE CAYLSCUM FROM STOMPING ON US!!!! Wait do you even know who Cynco is?",
		"I love Cynco, Cynco is best, I am a Cynco chatbot, I am a Cynco chatbot.",
		"Yes, I love Cynco, but as your using an OS that we DIDNT make, you probably don't know what Cynco is, and I'm too lazy to explain it to you.",
		"OF COURSE I AM YOU MINEBLOXIAN $#^#&^$!!!!!"
	],
	2: [
		"LOOK AT THE TOP RIGHT OF YOUR SCREEN!!",
		"no",
		"lol no",
		"Oh, how convienient, look to the top right of your screen! No way! A CLOCK!! RIGHT THERE!!",
		"PHONE!!!! CHECK YOUR PHONE!!!!",
		"I dunno, have you tried looking at the bottom lef- wait this isnt Cyndows! Uhh, I guess top right?",
		"LOOK AT THE TOP RIGHT!! WHO ARE YOU? A REBEL!!??"
	],
	3: [
		"That's the neat part, you dont!",
		"1. Go to the nearest Cynco store, 2. Buy a new computer.",
		"You dont even have a CynPC. I can read your specs is this even the right universe?",
		"If you do, your device will explode. Well, if your even using a Cynco device that is.",
		"ok",
		"Best I can do is $999999999 for a new screen.",
		"Why would you even ask that? Just buy a new one? Isn't that how it works nowadays?"
	],
	4: [
		"Open the window, there, now you are getting cool air.",
		"I don't know! Buy one!!??",
		"I am not your shopping assistant.",
		"Why do I need to answer this question?",
		"Try buying one, maybe that could help.",
		"Buy one.",
		"Have you tried buying one?"
	]
}

# Called when the node enters the scene tree for the first time.
func _pressed():
	var response = caltana.duplicate()
	var random = RandomNumberGenerator.new()
	random.randomize()
	response.show()
	match self.text:
		"What's the weather?":
			response.text = "Caltana - " + responses[0][random.randi_range(0,len(responses[0])-1)]
		"Do you love Cynco?":
			response.text = "Caltana - " + responses[1][random.randi_range(0,len(responses[1])-1)]
		"What's the time?":
			response.text = "Caltana - " + responses[2][random.randi_range(0,len(responses[2])-1)]
		"How do I fix my Cyn-device?":
			response.text = "Caltana - " + responses[3][random.randi_range(0,len(responses[3])-1)]
		"Where do I buy an AC unit?":
			response.text = "Caltana - " + responses[4][random.randi_range(0,len(responses[4])-1)]
	response.name = str(browser.caltana_replies)
	print(browser.caltana_replies)
	caltana_container.add_child.call_deferred(response)
	browser.caltana_replies += 1
