extends Sprite2D
@export var tiles: TileMapLayer
var pos = position

func _input(event):
	var tween = create_tween()
	if event.is_action_pressed("bug_up"):
		var target_pos = Vector2(pos.x, pos.y - 64)
		pos = target_pos
		tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_down"):
		var target_pos = Vector2(pos.x, pos.y + 64)
		pos = target_pos
		tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_left"):
		var target_pos = Vector2(pos.x - 64, pos.y)
		pos = target_pos
		tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
	elif event.is_action_pressed("bug_right"):
		var target_pos = Vector2(pos.x + 64, pos.y)
		pos = target_pos
		tween.tween_property(self, "position", target_pos, 0.2).set_ease(Tween.EASE_IN_OUT)
