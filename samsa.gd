extends CharacterBody2D
@export var roomholder: Node2D
@export var undo_button: Button
@export var face: Sprite2D
@export var bcounter: Label
@export var bstate: RichTextLabel
var tiles: TileMapLayer
var pos = position
var moving = false
var wall_positions: Array[Vector2i] = [] #strictly non-passable objects
var boxes: Array[Node2D] = []
var apples: Array[Node2D] = []
var all_tiles: Array[Vector2i] = []
var all_pits: Array[Vector2i] = [] #non-passable as man
signal done_moving
var bug = false
var bugrem = 0 #remaining turns as bug

func _ready():
	Global.roomholder = roomholder
	face.region_rect = Rect2(0,128,32,32)

func _process(_delta: float) -> void:
	if bug: 
		bstate.text = "[color=#a17a68][b]BUG[/b][/color]"
		if bugrem < 1 and (Vector2i((pos.x-32)/64,(pos.y-32)/64)) in all_pits:
			bcounter.text = "The bug state is indefinitely suspended while you're above a pit."
		else: bcounter.text = "Turns remaining as Bug: " + str(bugrem)
	else:
		bstate.text = "[color=#2f7544][b]MAN[/b][/color]"
		bcounter.text = "Eat an apple to transform into a bug!"

func push(cell,new):
	if tiles.get_cell_source_id(new) == -1:
		var source = tiles.get_cell_source_id(cell)
		var atlas = tiles.get_cell_atlas_coords(cell)
		#print(source,atlas)
		tiles.set_cell(cell, source, atlas)
		tiles.erase_cell(cell)

func move_to(tween,start,end):
	var do = true
	for box in boxes:
		#print(box.position,end)
		if box.position == end:
			if bug: return false
			do = box.push(start,end,boxes,wall_positions,all_pits,apples)
			print("push me!")
	for i in range(apples.size()):
		#print(apples)
		if apples[i].position == end:
			bug = true
			bugrem = Global.remission
			apples[i].visible = false
			apples.remove_at(i)
			break
	if (Vector2i((end.x-32)/64,(end.y-32)/64)) in all_pits and not bug:
		do = false
	if (Vector2i((end.x-32)/64,(end.y-32)/64)) not in wall_positions and do:
		set_undo()
		moving = true
		pos = end
		if bugrem > 0: bugrem -= 1
		tween.tween_property(self, "position", end, Global.move_time).set_ease(Tween.EASE_IN_OUT)
		if bugrem < 1 and (Vector2i((end.x-32)/64,(end.y-32)/64)) not in all_pits:
			bug = false
			face.region_rect = Rect2(0,128,32,32)

func _input(event):
	if event is InputEventKey and event.pressed and not moving:
		if event.is_action_pressed("undo"):
			do_undo()
		var tween = create_tween()
		if event.is_action_pressed("bug_up"):
			move_to(tween,pos,Vector2(pos.x, pos.y - 64))
		elif event.is_action_pressed("bug_down"):
			move_to(tween,pos,Vector2(pos.x, pos.y + 64))
		elif event.is_action_pressed("bug_left"):
			move_to(tween,pos,Vector2(pos.x - 64, pos.y))
		elif event.is_action_pressed("bug_right"):
			move_to(tween,pos,Vector2(pos.x + 64, pos.y))
		await get_tree().create_timer(Global.move_time).timeout
		if bug: face.region_rect = Rect2(0,32,32,32)
		moving = false
		emit_signal("done_moving")

func set_undo():
	var undo = {}
	var poses = []
	undo["pos"] = pos
	for box in boxes:
		poses.append([box,box.position])
	undo["apples"] = apples.duplicate()
	undo["poses"] = poses
	undo["bug"] = bug
	undo["bcount"] = bugrem
	Global.undo.append(undo)
	#print(Global.undo)
	undo_button.disabled = false

func do_undo():
	if len(Global.undo) > 0:
		var cur = Global.undo.pop_back()
		if moving: await self.done_moving
		var tween = create_tween()
		moving = true
		pos = cur["pos"]
		tween.tween_property(self, "position", pos, Global.move_time).set_ease(Tween.EASE_IN_OUT)
		for double in cur["poses"]:
			double[0].undo(double[1])
		for app in cur["apples"]:
			if app not in apples:
				apples.append(app)
				app.visible = true
		bug = cur["bug"]
		bugrem = cur["bcount"]
		if bug: face.region_rect = Rect2(0,32,32,32)
		else: face.region_rect = Rect2(0,128,32,32)
		await get_tree().create_timer(Global.move_time).timeout
		moving = false
	if len(Global.undo) == 0: undo_button.disabled = true
