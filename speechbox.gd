extends RichTextLabel
@export var goahead: Sprite2D
var povs = ["#f5f3ed","#bd7a59","#347536","#ed0000","#8843cc"]
var skip = false
signal unpress

func _ready() -> void:
	goahead.visible = false

func say_this(what,pov):
	goahead.visible = false
	skip = false
	self.text = "[color=" + povs[pov] + "]"
	for c in what:
		self.text = self.text + c
		if c != " " and not skip: await get_tree().create_timer(0.03).timeout
	self.text += "[/color]"
	goahead.visible = true
	await unpress

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		skip = true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		emit_signal("unpress")
