extends Node2D
@export var tiles: TileMapLayer
@export var boxiles: TileMapLayer
@export var appiles: TileMapLayer
var wall_positions: Array[Vector2i] = []
var boxes: Array[Node2D] = []
var apples: Array[Node2D] = []
var all_tiles: Array[Vector2i] = []
var all_pits: Array[Vector2i] = []
var all_doors: Array[Vector2i] = []
var exit_rooms = [null,"res://rooms/bedroom.tscn","res://rooms/kitchen.tscn",null]
var rem = 7

func _ready():
	for cell in tiles.get_used_cells(): # layer 0
		#var source_id = tiles.get_cell_source_id(cell)
		var atlas_coords = tiles.get_cell_atlas_coords(cell)
		if atlas_coords == (Vector2i(1,3)):
			all_pits.append(cell)
		if atlas_coords == (Vector2i(0,2)):
			all_doors.append(cell)
		if atlas_coords == (Vector2i(1,1)) or atlas_coords == (Vector2i(1,0)):
			wall_positions.append(cell)
		all_tiles.append(cell)
	for box in boxiles.get_used_cells():
		print("makebox",Vector2((box.x*64)+32,(box.y*64)+32))
		boxiles.erase_cell(box)
		var newbox = preload("res://box.tscn").instantiate()
		boxes.append(newbox)
		Global.roomholder.add_child.call_deferred(newbox)
		#print(get_parent())
		newbox.position = Vector2((box.x*64)+32,(box.y*64)+40)
	for apple in appiles.get_used_cells():
		print("makeapple",Vector2((apple.x*64)+32,(apple.y*64)+32))
		appiles.erase_cell(apple)
		var napple = preload("res://apple.tscn").instantiate()
		apples.append(napple)
		Global.roomholder.add_child.call_deferred(napple)
		#print(get_parent())
		napple.position = Vector2((apple.x*64)+32,(apple.y*64)+40)
	print(wall_positions)
	print(boxes)
	print(apples)
	#for box in boxes:
	#	print(box.position,box.global_position)

func reset_boxes(poses):
	for ind in range(boxes.size()):
		boxes[ind].position = poses[ind]

func give_birth():
	return boxes
