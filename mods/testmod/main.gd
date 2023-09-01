extends Node

func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	var cherry_wood = ModBlock.new()
	cherry_wood.sprite = ResourceLoader.load("res://mods/testmod/sprites/cherrywood.png")
	cherry_wood.block_icon = ResourceLoader.load("res://mods/testmod/sprites/cherrywood.png")
	cherry_wood.block_name = "cherry wood"
	ModLoader.add_block(cherry_wood)
