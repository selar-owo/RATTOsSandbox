extends Node2D

onready var root := self.get_parent().get_parent().get_parent()
onready var object_spawners = $".."
onready var tab_buttons = $TabButtons
onready var name_shower = $NameShower
onready var hud = $"../.."
var tween_progressing := false

func _ready():
	object_spawners.scale = Vector2(0.6,0.6)
	object_spawners.modulate.a = 0
	hide()

func _process(delta) -> void:
	name_shower.position = get_global_mouse_position()
	if Input.is_action_just_pressed("QMenu") and !tween_progressing and hud.openable:
		toggle_os_state()

func toggle_nameshower_state(state):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	if state == "show":
		var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(name_shower,"modulate:a",1,0.5)
		tween_rotation.tween_property(name_shower,"rotation_degrees",0,0.5)
	if state == "hide":
		var tween_rotation := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(name_shower,"modulate:a",0,0.5)
		tween_rotation.tween_property(name_shower,"rotation_degrees",10,0.5)

func toggle_os_state(state=null):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_transparency := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	if self.visible or state == "close":
		tween.tween_property(object_spawners,"scale",Vector2(0.8,0.8),0.5)
		tween_progressing = true
		yield(tween_transparency.tween_property(object_spawners,"modulate:a",0,0.5),"finished")
		tween_progressing = false
		self.hide()
	elif !self.visible or state == "open":
		self.show()
		tween.tween_property(object_spawners,"scale",Vector2(1,1),0.5)
		tween_progressing = true
		for i in tab_buttons.get_children():
			i.on_de_hover()
		yield(tween_transparency.tween_property(object_spawners,"modulate:a",1,0.5),"finished")
		tween_progressing = false

