extends TextureButton

export(String) var objname
export(String) var obj

func _on_QmenuButton_mouse_entered():
	$Label.show()

func _on_QmenuButton_mouse_exited():
	$Label.hide()

func summonBlock():
	if Globals.menuCloses == true:
		Globals.QmenuOpen = false
	var block = load(obj).instance()
	get_tree().add_child(block)

func _on_QmenuButton_button_up():
	summonBlock()
