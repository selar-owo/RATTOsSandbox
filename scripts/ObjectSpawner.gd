extends Node2D

onready var root := self.get_parent().get_parent().get_parent()
onready var object_spawners = $".."
onready var tab_buttons = $TabButtons
var tween_progressing := false

func _ready():
	object_spawners.scale = Vector2(0.6,0.6)
	object_spawners.modulate.a = 0
	hide()

func _process(delta) -> void:
	if Input.is_action_just_pressed("QMenu") and !tween_progressing:
		var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		var tween_transparency := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		if self.visible:
			tween.tween_property(object_spawners,"scale",Vector2(0.8,0.8),0.5)
			tween_progressing = true
			yield(tween_transparency.tween_property(object_spawners,"modulate:a",0,0.5),"finished")
			tween_progressing = false
			self.hide()
		else:
			self.show()
			tween.tween_property(object_spawners,"scale",Vector2(1,1),0.5)
			tween_progressing = true
			for i in tab_buttons.get_children():
				i.on_de_hover()
			yield(tween_transparency.tween_property(object_spawners,"modulate:a",1,0.5),"finished")
			tween_progressing = false

