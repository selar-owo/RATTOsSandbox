extends Node2D

export var do_starting_animation := true

func _ready():
	if do_starting_animation:
		self.modulate.a = 0
		var tween := get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self,"modulate:a",1,1)
