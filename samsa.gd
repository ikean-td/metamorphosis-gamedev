extends CharacterBody2D
@export var tiles: TileMapLayer
var pos = position
var wall_positions: Array[Vector2i] = []

func _ready():
	for cell in tiles.get_used_cells(): # layer 0
		#var source_id = tiles.get_cell_source_id(cell)
		var atlas_coords = tiles.get_cell_atlas_coords(cell)
		if atlas_coords == (Vector2i(1,1)):
			wall_positions.append(cell)
	print(wall_positions)

func _input(event):
	var tween = create_tween()
	if event.is_action_pressed("bug_up"):
		var target_pos = Vector2(pos.x, pos.y - 64)
		if (Vector2i((target_pos.x-32)/64,(target_pos.y-32)/64)) not in wall_positions:
			pos = target_pos
			tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_down"):
		var target_pos = Vector2(pos.x, pos.y + 64)
		if (Vector2i((target_pos.x-32)/64,(target_pos.y-32)/64)) not in wall_positions:
			pos = target_pos
			tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_left"):
		var target_pos = Vector2(pos.x - 64, pos.y)
		if (Vector2i((target_pos.x-32)/64,(target_pos.y-32)/64)) not in wall_positions:
			pos = target_pos
			tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_right"):
		var target_pos = Vector2(pos.x + 64, pos.y)
		if (Vector2i((target_pos.x-32)/64,(target_pos.y-32)/64)) not in wall_positions:
			pos = target_pos
			tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
