extends StaticBody2D

onready var inside = $Inside
onready var outside = $Outside

func _ready():
	inside.hide()
	outside.show()

func _on_InsideDetector_area_entered(area):
	if area.get_name() == "intArea":
		inside.show()
		var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(outside,"modulate:a",0.0,1)
		tween.play()
		tween.connect("finished",self,"toggle",[false,outside])

func _on_InsideDetector_area_exited(area):
	if area.get_name() == "intArea":
		outside.show()
		var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(outside,"modulate:a",1.0,1)
		tween.play()
		tween.connect("finished",self,"toggle",[false,inside])

func toggle(toggle,which):
	which.visible = toggle
