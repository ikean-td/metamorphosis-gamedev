extends Node
var current_room: Node
@export var player: CharacterBody2D
@export var roomholder: Node2D

func _ready():
	add_to_group("room_manager")

func load_room(room: String, location: int):
	#gets the path for the room, then the doorway which it enters.
	#0 means enter from left, 1 from top, 2 from right, 3 from bottom.
	if current_room:
		current_room.queue_free()
		
	var new_room = load(room).instantiate()
	roomholder.add_child(new_room)
	player.tiles = new_room.get_child(0)
	player.wall_positions = new_room.wall_positions
	player.boxes = new_room.boxes
	player.apples = new_room.apples
	player.all_tiles = new_room.all_tiles
	player.all_pits = new_room.all_pits
	player.all_doors = new_room.all_doors
	player.exit_rooms = new_room.exit_rooms
	player.rname = room
	Global.remission = new_room.rem
	#print(roomholder.get_child(0))
	current_room = new_room
	
	if room not in Global.roomstates:
		Global.roomstates[room] = []
	else: new_room.reset_boxes(Global.roomstates[room])
	
	if location == 0: return Vector2(96.0,player.pos.y) #left
	if location == 1: return Vector2(player.pos.x,232.0) #top
	if location == 2: return Vector2(1056.0,player.pos.y) #right
	if location == 3: return Vector2(player.pos.x,552.0) #bottom
	#player.pos = player.position
