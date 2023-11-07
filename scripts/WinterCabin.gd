extends StaticBody2D

onready var inside = $Inside
onready var outside = $Outside

func _ready():
	inside.hide()
	outside.show()

func _on_InsideDetector_area_entered(area):
	pass # Replace with function body.

func _on_InsideDetector_area_exited(area):
	pass # Replace with function body.
