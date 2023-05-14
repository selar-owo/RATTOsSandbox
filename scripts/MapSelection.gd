extends Node2D

onready var press_noise:Node = $"../ButtonPress"
onready var hover_noise := $"../Hover"
onready var camera:Node = $"../Camera2D"
onready var LoadingScreen:Node = $"../Camera2D/LoadingScreen"
onready var mapInfo:Node = $MapInfo
onready var tween:Node = $Tween
onready var main_menu = $".."

func _on_Exit_button_up():
	main_menu.move_camera(Vector2(512,300),1)

func load_map(map):
	press_noise.play()
	print("Loading Map Location: ",map)
	randomize()
	LoadingScreen.show()
	yield(get_tree().create_timer(rand_range(0.1,0.2)),"timeout")
	get_tree().change_scene(map)

func _on_TestLands_button_up():
	load_map("res://scenes/Maps/TilemapTest.tscn")

func _on_BadConstruct_button_up():
	load_map("res://scenes/Maps/MidConstruct.tscn")

func _on_Blank_button_up():
	load_map("res://scenes/Maps/Blank.tscn")

func _on_Flatlands_button_up():
	load_map("res://scenes/Maps/Flatlands.tscn")

func _on_Island_button_up():
	load_map("res://scenes/Maps/RainyIsland.tscn")

func _on_mouse_exited():
	mapInfo.text = ""
	hover($MapSelections/TestLands,false,$MapSelections/TestLands/Label)
	hover($MapSelections/BadConstruct,false,$MapSelections/BadConstruct/Label)
	hover($MapSelections/Blank,false,$MapSelections/Blank/Label)
	hover($MapSelections/Flatlands,false,$MapSelections/Flatlands/Label)
	hover($MapSelections/Island,false,$MapSelections/Island/Label)

func hover(obj,hoverOrNot,objtxt):
	if hoverOrNot:
		hover_noise.play()
		objtxt.modulate = Color(0.75, 0.86, 1)
		tween.interpolate_property(obj,"rect_position:x",obj.rect_position.x,43,0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween.start()
	else:
		objtxt.modulate = Color(1,1,1)
		tween.interpolate_property(obj,"rect_position:x",obj.rect_position.x,23,0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween.start()

func _on_TestLands_mouse_entered():
	mapInfo.text = "basic tilemap\ncrazy"
	hover($MapSelections/TestLands,true,$MapSelections/TestLands/Label)

func _on_BadConstruct_mouse_entered():
	mapInfo.text = "funny construct\nbut bad"
	hover($MapSelections/BadConstruct,true,$MapSelections/BadConstruct/Label)

func _on_Blank_mouse_entered():
	mapInfo.text = "Blank.\nLiterally Nothing.\nGo Blank."
	hover($MapSelections/Blank,true,$MapSelections/Blank/Label)

func _on_Flatlands_mouse_entered():
	mapInfo.text = "quite flat, isnt it?"
	hover($MapSelections/Flatlands,true,$MapSelections/Flatlands/Label)

func _on_Island_mouse_entered():
	mapInfo.text = "i hate this\nisland it sucks so\nmuch smh..."
	hover($MapSelections/Island,true,$MapSelections/Island/Label)

func _on_go_to_fakiling_button_up():
	load_map("res://scenes/Maps/Facility.tscn")
