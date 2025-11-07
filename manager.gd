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
	player.tiles = roomholder.get_child(0).find_child("tiles")
	#print(roomholder.get_child(0))
	current_room = new_room
	
	if location == 0: player.position = Vector2(96.0,352.0)
	if location == 1: player.position = Vector2(544.0,96.0)
	if location == 2: player.position = Vector2(1056.0,352.0)
	if location == 3: player.position = Vector2(544.0,544.0)
	player.pos = player.position
