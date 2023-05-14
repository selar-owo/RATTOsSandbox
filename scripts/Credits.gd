extends Node2D

onready var selar_socials := $Selar/Socials
onready var kriz_socials := $Kriz/Socials
onready var hover_see := $hover
onready var camera := $"../Camera2D"

var kriz_on := false
var selar_on := false

func _on_Twitter_button_up():
	OS.shell_open("https://twitter.com/smelly_selar")

func _on_Youtube_button_up():
	OS.shell_open("https://www.youtube.com/@justshitmyself")

func _on_Kriz_Youtube_button_up():
	OS.shell_open("https://www.youtube.com/@krizrealnofake")

func _on_Exit_button_up():
	camera.position = Vector2(512,300)

func _on_Kriz_button_up():
	hover_see.hide()
	kriz_on = !kriz_on
	if kriz_on:
		kriz_socials.show()
	else:
		kriz_socials.hide()

func _on_Selar_button_up():
	hover_see.hide()
	selar_on = !selar_on
	if selar_on:
		selar_socials.show()
	else:
		selar_socials.hide()
