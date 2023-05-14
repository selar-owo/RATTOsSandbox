extends TextureRect

onready var anim:Node = $AnimationPlayer

func _on_Area2D_area_entered(area):
	if area.get_name() == "intArea":
		anim.play("Inside")
		print("going inside")

func _on_Area2D_area_exited(area):
	if area.get_name() == "intArea":
		anim.play_backwards("Inside")
		print("going outside")
