extends Node2D

func open_tab():
	self.scale = Vector2(0.8,0.8)
	self.modulate.a = 0.4
	self.show()
	var tween_scale := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_modulate := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween_scale.tween_property(self,"scale",Vector2(1,1),0.5)
	tween_modulate.tween_property(self,"modulate:a",1,0.5)
