extends Node

var save_path := "user://save-file.cfg"
var config := ConfigFile.new()
var load_response := config.load(save_path)

func _ready():
	pass

func save_cfg(section,key,value):
	config.set_value(section,key,value)
	config.save(save_path)

func load_cfg(section,key):
	return config.get_value(section,key)
