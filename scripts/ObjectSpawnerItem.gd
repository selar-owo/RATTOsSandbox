extends NinePatchRect

var root
var object_folder
var os
export var block_scene = "a"
export var block_icon:Resource
export var block_name:String
export var is_path := true
onready var click_detector = $ClickDetector
onready var icon = $IconHolder/Icon
onready var icon_holder = $IconHolder
onready var label_name = $"../../../../NameShower/Name"

var past_modulate

func _ready() -> void:
	past_modulate = self.self_modulate
	os = self.get_parent().get_parent().get_parent().get_parent()
	root = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	find_object_folder()
	setup_icon()
	click_detector.connect("button_up",self,"on_click")
	click_detector.connect("mouse_entered",self,"on_hover")
	click_detector.connect("mouse_exited",self,"on_de_hover")

func on_click() -> void:
	var block 
	if is_path:
		block = block_scene.instance()
	else:
		block = block_scene.duplicate()
	object_folder.add_child(block)
	os.toggle_os_state("close")

func on_hover() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_modulate := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(icon_holder,"scale",Vector2(5.263,5.263),0.5)
	tween_rotation.tween_property(icon_holder,"rotation_degrees",-2,0.5)
	tween_modulate.tween_property(self,"self_modulate",past_modulate + Color(0.4,0.4,0.4,0),0.5)
	label_name.text = block_name
	os.toggle_nameshower_state("show")

func on_de_hover() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_modulate := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(icon_holder,"scale",Vector2(5.063,5.063),0.5)
	tween_rotation.tween_property(icon_holder,"rotation_degrees",0,0.5)
	tween_modulate.tween_property(self,"self_modulate",past_modulate,0.5)
	os.toggle_nameshower_state("hide")

func find_object_folder() -> void:
	for i in root.get_children():
		if i.get_name() == "Objects":
			object_folder = i
			return

func setup_icon() -> void:
	icon.set_texture(block_icon)
