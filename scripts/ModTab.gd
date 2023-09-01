extends "res://scripts/Tab.gd"

func _ready() -> void:
	for i in ModLoader.modded_items:
		items_in_tab.append(i)
		print("Loaded ",i["block_name"])
	load_tabs()
