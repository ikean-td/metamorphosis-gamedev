extends Node
@export var speech: RichTextLabel
@export var player: CharacterBody2D
signal next_please

func _ready() -> void:
	#POVS, 0 = narrator, 1 = gregor(bug), 2 = gregor(man), 3 = father, 4 = mother
	await speech.say_this("When Gregor Samsa awoke from terrible dreams...",0)
	await next_please
	await speech.say_this("He found himself transformed into a gigantic insect.",0)
	await next_please
	await speech.say_this("What time is it?",1)
	await next_please
	await speech.say_this("Oh no! I think I'm going to be late for work!",1)
	await next_please
	await speech.say_this("Are you in there, Gregor?",3)
	await next_please
	await speech.say_this("I'll be there in a second!",1)
	await next_please
	await speech.say_this("I think he's come down with a cold, dear.",4)
	await next_please
	await speech.say_this("Ugh, I feel so strange. I should try getting to the door with WASD.",1)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.to_man
	player.can_move = false
	await speech.say_this("I'm feeling a bit better. There's something in front of my door, I should probably move it.",2)
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.room_shift
	player.can_move = false
	await speech.say_this("Where is everyone?",2)
	await next_please
	await speech.say_this("Gregor, are you doing okay?",4)
	await next_please
	await speech.say_this("Yeah, mom, I'll be down in a moment!",2)
	await next_please
	await speech.say_this("Who left an apple there on the floor? ...Whatever, I need to find a way over that pit.",2)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.to_bug
	player.can_move = false
	await speech.say_this("I feel so weird. At least now I think I can make it over that pit.",1)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.room_shift
	player.can_move = false
	await speech.say_this("Am I going in circles?",2)
	await next_please
	await speech.say_this("What's with all these boxes? I've gotta get downstairs...",2)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.to_bug
	player.can_move = false
	await speech.say_this("GREGOR!",3)
	await next_please
	await speech.say_this("I'm coming, just give me a minute!",1)
	await next_please
	await speech.say_this("Oh dear, what was that horrid noise!? It sounded like a cockroach...",4)
	await next_please
	await speech.say_this("I need to find my way over this pit. Luckily, if I make any mistakes, I can backtrack by pressing X.",1)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.room_shift
	player.can_move = false
	await speech.say_this("I feel sick...",2)
	await next_please
	await speech.say_this("My mind feels like a fog. I just need to get to work...",2)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.to_bug
	player.can_move = false
	await speech.say_this("I feel like it's getting harder to move...",1)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.room_shift
	player.can_move = false
	await speech.say_this("Were the hallways always this tight?",2)
	await next_please
	await speech.say_this("Mom, dad, are you there?!",2)
	await next_please
	await speech.say_this("...",3)
	await next_please
	await speech.say_this("...",4)
	await next_please
	await speech.say_this("This is just a bad dream...",2)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true
	await player.room_shift
	await player.to_bug
	player.can_move = false
	await speech.say_this("I'm making it out, finally.",1)
	await next_please
	await speech.say_this("What is that?",4)
	await next_please
	await speech.say_this("Is that really...?",4)
	await next_please
	await speech.say_this("Leave him.",3)
	await next_please
	await speech.say_this("...",1)
	await next_please
	await speech.say_this("I need to get to work.",1)
	await next_please
	speech.text = ""; speech.goahead.visible = false; player.can_move = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("next_please")
