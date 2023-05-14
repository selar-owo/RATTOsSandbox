extends TextureButton

export var map_resource:Resource = preload("res://scenes/Maps/RainyIsland.tscn")
export var map_name:String = "Basic Name"
export(String,MULTILINE) var map_desc = "Basic Description"

var sel_pos

onready var hover = $"../../Hover"
onready var map_selection = $"../.."

signal toggle_name(toggle,name,desc)

func _ready():
	sel_pos = self.rect_position.y - 10
	self.connect("mouse_entered",self,"_on_hover",[true])
	self.connect("mouse_exited",self,"_on_hover",[false])
	self.connect("button_up",self,"_on_press")

func _on_press():
	map_selection.load_map(map_resource)

func _on_hover(press):
	emit_signal("toggle_name",press,map_name,map_desc)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	if press:
		tween.tween_property(self,"rect_position:y",sel_pos,0.5)
		hover.play()
	else:
		tween.tween_property(self,"rect_position:y",sel_pos + 10,0.5)
