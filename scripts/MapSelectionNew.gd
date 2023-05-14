extends Control

onready var name_point = $NamePoint
onready var name_label = $NamePoint/NameLabel
onready var description = $Description

onready var main_menu = $".."
onready var loading_screen = $"../Camera2D/LoadingScreen"
onready var button_press = $"../ButtonPress"

func _ready():
	description.text = "basic description" 
	description.add_color_override("font_color",Color(0.509804, 0.509804, 0.509804))
	name_point.hide()

func _process(delta):
	map_name_follows_mouse()

func load_map(map):
	button_press.play()
	print("Loading Map Location: ",map)
	randomize()
	loading_screen.show()
	yield(get_tree().create_timer(rand_range(0.5,0.7)),"timeout")
	get_tree().change_scene_to(map)

func map_name_follows_mouse() -> void:
	name_point.position = get_local_mouse_position()

func _on_toggle_name(toggle,name,desc):
	name_label.text = name
	name_point.visible = toggle
	if toggle == true:
		description.add_color_override("font_color",Color(1,1,1))
		description.text = desc
#		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
#		name_point.scale = Vector2(1.2,1.2)
#		tween.tween_property(name_point,"scale",Vector2(1,1),0.5)
#		tween.stop()
#		tween.play()
	else:
		description.text = "basic description" 
		description.add_color_override("font_color",Color(0.509804, 0.509804, 0.509804))

func _on_Exit_button_up():
	main_menu.move_camera(Vector2(512,300),1)
