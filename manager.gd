extends Node
var current_room: Node
@export var player: CharacterBody2D
@export var roomholder: Node2D

func _ready():
	add_to_group("room_manager")
	load_room("res://rooms/bedroom.tscn",0)

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
	#print(roomholder.get_child(0))
	current_room = new_room
	
	if location == 0: player.position = Vector2(96.0,360.0)
	if location == 1: player.position = Vector2(544.0,104.0)
	if location == 2: player.position = Vector2(1056.0,360.0)
	if location == 3: player.position = Vector2(544.0,552.0)
	player.pos = player.position
