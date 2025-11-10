extends CharacterBody2D
@export var roomholder: Node2D
@export var manager: Node
@export var undo_button: Button
@export var face: Sprite2D
@export var bcounter: Label
@export var bstate: RichTextLabel
@export var curtain: Sprite2D
var rname: String
var tiles: TileMapLayer
var pos = position
var moving = false
var can_move = false
var wall_positions: Array[Vector2i] = [] #strictly non-passable objects
var boxes: Array[Node2D] = []
var apples: Array[Node2D] = []
var all_tiles: Array[Vector2i] = []
var all_pits: Array[Vector2i] = [] #non-passable as man
var all_doors: Array[Vector2i] = [] #doors
var exit_rooms = [null,null,null,null] #all exits for each dir. left,up,right,down
signal done_moving
signal to_man
signal to_bug
signal room_shift
var bug = true
var bugrem = Global.remission #remaining turns as bug

func _ready():
	Global.roomholder = roomholder
	face.region_rect = Rect2(0,32,32,32)
	manager.load_room("res://rooms/bedroom.tscn",0)
	pos = Vector2(160.0, 360.0)
	self.position = pos
	undo_button.disabled = true

func _process(_delta: float) -> void:
	if bug: 
		bstate.text = "[color=#a17a68][b]BUG[/b][/color]"
		if bugrem < 1 and (Vector2i((pos.x-32)/64,(pos.y-32)/64)) in all_pits:
			bcounter.text = "Move off of a pit tile to return to human!"
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
			do = box.push(start,end,boxes,wall_positions,all_pits,apples,all_doors)
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
		if bugrem < 1 and (Vector2i((end.x-32)/64,(end.y-32)/64)) not in all_pits:
			bug = false
			face.region_rect = Rect2(0,128,32,32)
			emit_signal("to_man")
		if (Vector2i((end.x-32)/64,(end.y-32)/64)) in all_doors:
			var twee = create_tween()
			curtain.visible = true
			curtain.self_modulate.a = 0
			twee.tween_property(curtain,"self_modulate:a",1,Global.move_time*2)
			tween.tween_property(self, "position", end + (end - start), Global.move_time*2).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(func(): door_trans(end,twee))
			await get_tree().create_timer(Global.move_time*4).timeout
			emit_signal("done_moving")
		else: 
			tween.tween_property(self, "position", end, Global.move_time).set_ease(Tween.EASE_IN_OUT)
			await get_tree().create_timer(Global.move_time).timeout
			emit_signal("done_moving")

func door_trans(end,twee):
	#FULL CLEAR ON UNDOS, SETS YOU TO MAN
	if bug: emit_signal("to_man")
	bug = false
	bugrem = 0
	Global.undo.clear()
	face.region_rect = Rect2(0,128,32,32)
	emit_signal("room_shift")
	#SAVES ALL BOX STATES FOR IF THE ROOM IS RELOADED
	var boxposes = []
	for box in boxes:
		boxposes.append(box.position)
	Global.roomstates[rname] = boxposes.duplicate()
	print("move to new room")
	var goto: Vector2
	var start: Vector2
	if end.x == 32.0: #left
		goto = manager.load_room(exit_rooms[0],2)
		start = goto + Vector2(128,0)
	if end.y == 168.0: #top
		goto = manager.load_room(exit_rooms[1],3)
		start = goto + Vector2(0,128)
	if end.x == 1120.0: #right
		goto = manager.load_room(exit_rooms[2],0)
		start = goto - Vector2(128,0)
	if end.y == 616.0: #bottom
		goto = manager.load_room(exit_rooms[3],1)
		start = goto - Vector2(0,128)
		print("go down")
	self.position = start
	pos = goto
	twee.kill()
	var twah = create_tween()
	twah.tween_property(curtain,"self_modulate:a",0,Global.move_time*2)
	var twoh = create_tween()
	#twee.tween_callback(func(): curtain.visible = false)
	#await get_tree().create_timer(Global.move_time).timeout
	twoh.tween_property(self, "position", pos, Global.move_time*3).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)

func _input(event):
	if event is InputEventKey and event.pressed and not moving and can_move:
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
		await done_moving
		if bug: face.region_rect = Rect2(0,32,32,32); emit_signal("to_bug")
		moving = false
		print(pos,position)

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
	if len(Global.undo) > 0 and can_move:
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
		if bug: face.region_rect = Rect2(0,32,32,32); emit_signal("to_bug")
		else: face.region_rect = Rect2(0,128,32,32); emit_signal("to_man")
		await get_tree().create_timer(Global.move_time).timeout
		moving = false
	if len(Global.undo) == 0: undo_button.disabled = true
