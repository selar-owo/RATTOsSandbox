extends "res://scripts/BlockHandler.gd"
class_name ModBlock

var block_name := "use block_name to rename"
var block_icon := preload("res://sprites/`missingtexture.png")
var block_sprite := preload("res://sprites/`missingtexture.png")
onready var sprite_node = $Sprite

func _ready():
	print("modblock created")
	sprite_node.set_texture(block_sprite)
