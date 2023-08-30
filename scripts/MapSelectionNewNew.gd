extends Node2D

onready var main_menu = $"../.."
onready var loading_screen = $"../../../LoadingScreen"

func load_map(map,map_fallback):
	main_menu.play_sound(1)
	print("Loading Map Location: ",map)
	randomize()
	loading_screen.show()
	yield(get_tree().create_timer(rand_range(0.5,0.7)),"timeout")
	get_tree().change_scene_to(map)
