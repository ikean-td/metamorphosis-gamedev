extends CharacterBody2D
var tiles: TileMapLayer
var pos = position
var wall_positions: Array[Vector2i] = []
var box_positions: Array[Vector2i] = []
var all_tiles: Array[Vector2i] = []
var moving = false

func _ready():
	for cell in tiles.get_used_cells(): # layer 0
		#var source_id = tiles.get_cell_source_id(cell)
		var atlas_coords = tiles.get_cell_atlas_coords(cell)
		if atlas_coords == (Vector2i(1,1)):
			wall_positions.append(cell)
		if atlas_coords == (Vector2i(1,2)):
			box_positions.append(cell)
		all_tiles.append(cell)
	print(wall_positions)

func push(cell,new):
	if tiles.get_cell_source_id(new) == -1:
		var source = tiles.get_cell_source_id(cell)
		var atlas = tiles.get_cell_atlas_coords(cell)
		print(source,atlas)
		tiles.set_cell(cell, source, atlas)
		tiles.erase_cell(cell)

func move_to(tween,start,end):
	if (Vector2i((end.x-32)/64,(end.y-32)/64)) in box_positions:
		push((Vector2i((start.x-32)/64,(start.y-32)/64)),(Vector2i((end.x-32)/64,(end.y-32)/64)))
		print("boxed out!",start,end)
	if (Vector2i((end.x-32)/64,(end.y-32)/64)) not in wall_positions:
		moving = true
		pos = end
		tween.tween_property(self, "position", end, 0.2).set_ease(Tween.EASE_IN_OUT)

func _input(event):
	if not moving:
		var tween = create_tween()
		if event.is_action_pressed("bug_up"):
			move_to(tween,pos,Vector2(pos.x, pos.y - 64))
		elif event.is_action_pressed("bug_down"):
			move_to(tween,pos,Vector2(pos.x, pos.y + 64))
		elif event.is_action_pressed("bug_left"):
			move_to(tween,pos,Vector2(pos.x - 64, pos.y))
		elif event.is_action_pressed("bug_right"):
			move_to(tween,pos,Vector2(pos.x + 64, pos.y))
		await get_tree().create_timer(0.1).timeout
		moving = false
