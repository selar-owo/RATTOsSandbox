extends Node2D

onready var camera:Node = $"../Camera2D"

func _on_Exit_button_up():
	camera.position.x = 512
