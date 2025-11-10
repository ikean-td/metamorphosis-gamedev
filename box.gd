extends Node2D

func push(start,end,boxes,walls,pits,apples,doors):
	var dir = (end - start) + end
	var do = true
	var appos = []
	for app in apples:
		appos.append(app.position)
	print("appos",appos)
	for box in boxes:
		print("doubles", dir, box.position)
		if dir == box.position:
			print("chain push")
			if not box.push(end,dir,boxes,walls,pits,apples,doors): return false
	if Vector2i((dir.x-32)/64,(dir.y-32)/64) not in walls and Vector2i((dir.x-32)/64,(dir.y-32)/64) not in pits and Vector2i((dir.x-32)/64,(dir.y-32)/64) not in doors and dir not in appos and do:
		var tween = create_tween()
		print(end+dir)
		tween.tween_property(self,"position",dir,Global.move_time).set_ease(Tween.EASE_IN_OUT)
		return true
	else:
		return false

func undo(to):
	var tween = create_tween()
	tween.tween_property(self, "position", to, Global.move_time).set_ease(Tween.EASE_IN_OUT)
