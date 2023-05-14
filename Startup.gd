extends Node2D

func _on_Button_button_up():
	$AnimationPlayer.play("Startup")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/UIs/MainMenu.tscn")

func _on_LinkButton_button_up():
	OS.shell_open("https://www.youtube.com/@DMDOKURO")
