extends NinePatchRect

export(NodePath) var path_tab
onready var tabs = $"../../Tabs"
onready var tab_buttons = $".."
onready var click_detector = $ClickDetector
onready var tab
onready var icon = $Icon

onready var stjupd = $"../.."
onready var nameshower = $"../../NameShower/Name"

func _ready() -> void:
	hide_all_tabs()
	tab = get_node(path_tab)
	click_detector.connect("button_up",self,"on_press")
	click_detector.connect("mouse_entered",self,"on_hover")
	click_detector.connect("mouse_exited",self,"on_de_hover")

func on_press() -> void:
	hide_all_tabs()
	tab.open_tab()
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"rect_position:y",65,1)

func on_hover() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var tween_scale := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"rect_scale",Vector2(1.03,1.03),1)
	tween_rotation.tween_property(icon,"rotation_degrees",-5,1)
	tween_scale.tween_property(icon,"scale",Vector2(2.45,2.45),1)
	nameshower.text = self.name
	stjupd.toggle_nameshower_state("show")

func on_de_hover() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var tween_scale := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"rect_scale",Vector2(1,1),1)
	tween_rotation.tween_property(icon,"rotation_degrees",0,1)
	tween_scale.tween_property(icon,"scale",Vector2(2.25,2.25),1)
	stjupd.toggle_nameshower_state("hide")

func hide_all_tabs():
	for i in tabs.get_children():
		i.hide()
	for i in tab_buttons.get_children():
		var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(i,"rect_position:y",69,1)
