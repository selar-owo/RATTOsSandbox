extends Node

"""
health bar styles:

bar
heart
plus
number

"""

var save_path := "user://save-file.cfg"
var config := ConfigFile.new()
var load_response := config.load(save_path)

func _ready():
	var file = File.new()
	if !file.file_exists(save_path):
		config.set_value("VisualsAudio","Volume",0)
		config.set_value("VisualsAudio","Fullscreen",true)
		config.set_value("VisualsAudio","ShowFPS",true)
		config.set_value("VisualsAudio","ShowUseIndicator",true)
		config.set_value("VisualsAudio","PhysColor",Color(0.666667, 0.780392, 1))
		config.set_value("VisualsAudio","HealthBarStyle","bar")
		config.set_value("VisualsAudio","Zoom",0.6)
		
		config.set_value("PhysicsStuff","MaxHealth",200)
		
		config.set_value("Experimental","InteractPhysics",false)
		config.set_value("Experimental","Music",false)
		config.set_value("Experimental","Glow",false)
		config.set_value("Experimental","Mods",true)
		config.set_value("Experimental","GenerateTrailWhenShootingAir",true)
		
		config.set_value("UpdatedChecker","Version",Globals.version_number[0])
		config.save(save_path)

func save_cfg(section,key,value):
	config.set_value(section,key,value)
	config.save(save_path)

func load_cfg(section,key):
	return config.get_value(section,key)
