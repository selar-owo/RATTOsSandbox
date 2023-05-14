extends Node

const SAVE_FILE = "user://save_file.gloobies" 
var game_data = {}

func _ready():
	load_data()

func save_data():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(game_data)
	file.close()
	print("SAVED ALL DATA")

func load_data():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		game_data = {
			"meat_beaten": false
		}
		save_data()
	file.open(SAVE_FILE, File.READ)
	game_data = file.get_var()
	file.close()
	print("LOADED ALL DATA")

func erase_data():
	var dir = Directory.new()
	dir.remove("user://save_file.gloobies" )
#	game_data = {
#		"goobs": 0,
#		"headphones": false,
#		"goobPerClick": 1,
#		"charger": 0,
#		"goobPerSecond": 0,
#		"tophat": false,
#		"catType": 1,
#	}
	print("ERASED ALL DATA")
	get_tree().quit()
