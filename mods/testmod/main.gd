extends Node

func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	var cherry_wood = ResourceLoader.load("res://mods/purefreedomapi/scenes/ModBlock.tscn").instance()
	cherry_wood.block_sprite = ResourceLoader.load("res://mods/testmod/sprites/cherrywood.png")
	cherry_wood.block_icon = ResourceLoader.load("res://mods/testmod/sprites/cherrywood.png")
	cherry_wood.block_name = "cherry wood"
	ModLoader.add_block(cherry_wood)
	
	var fartcaca = ResourceLoader.load("res://mods/purefreedomapi/scenes/ModBlock.tscn").instance()
	fartcaca.block_sprite = ResourceLoader.load("res://sprites/BadConstructCloudImage.png")
	fartcaca.block_icon = ResourceLoader.load("res://sprites/Clog.png")
	fartcaca.block_name = "fart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssssfart cacafdsssssssssss"
	ModLoader.add_block(fartcaca)
