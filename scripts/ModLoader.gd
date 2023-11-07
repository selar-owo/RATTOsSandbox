extends Node

var modded_items := [
	{
		"block_scene": preload("res://scenes/blocks/Tree.tscn"),
		"block_icon": preload("res://sprites/AemiaStronger.png"),
		"block_name": "cool modded item"
	}
]

func _ready():
	if SaveSettings.load_cfg("Experimental","Mods"):
		load_mods()

func load_mods():
	var caca = Directory.new()
	var fartsghit6 = Directory.new()
	if !caca.dir_exists("user://mods/"):
		fartsghit6.make_dir("user://mods/")
		print("made mods directory")
	
	var files = []
	var dir = Directory.new()
	dir.open("user://mods/")
	dir.list_dir_begin(true,false)
	print("started the list at ",dir.get_current_dir())
	
	while true:
		var file = dir.get_next()
		print("trying to load ",file)
		if file.begins_with("."):
			print("mod doesnt need meet .begins_with requirements ", file)
			return
		elif file.get_extension() == "pck":
			print("attempting to load ",file)
			var success = ProjectSettings.load_resource_pack(str("user://mods/",file),true)
			
			if success:
				print("succesfully loaded ",file)
				files.append(file)
				break
		else:
			print("mod doesnt need meet .get_extension requirements ", file)
	print("done loading all mods I FUCKING HOPE")
	
	dir.list_dir_end()

func add_block(block):
	print(block)
	modded_items.append(
		{
			"block_scene": block,
			"block_icon": block.block_icon,
			"block_name": block.block_name,
			"is_path": false,
		}
	)
