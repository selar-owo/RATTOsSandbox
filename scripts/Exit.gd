extends LinkButton

func _on_Exit_mouse_entered():
	$Hover.play()

func _on_Exit_button_up():
	$Clicked.play()
