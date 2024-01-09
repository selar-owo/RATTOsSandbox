extends Node2D

onready var ui = $"../../.."

func _TrashButton_Pressed():
	pass

func _UndoButton_Pressed():
	for i in ui.objects.get_children():
		i.queue_free()
		yield(get_tree().create_timer(0.05),"timeout")

func _ClearCorpseButton_Pressed():
	var childrenAmount = -1
	
	for n in ui.objects.get_children():
		childrenAmount += 1
	
	if ui.objects.get_child_count() > 0:
		if ui.objects.get_child(ui.objects.get_child_count() - 1).get_child(0).get_name() == "vehicle":
			Globals.insideVehicle = false
		print("Deleted ",ui.objects.get_child(childrenAmount))
		ui.objects.get_child(childrenAmount).queue_free()
