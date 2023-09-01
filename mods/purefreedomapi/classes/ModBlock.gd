extends RigidBody2D
class_name ModBlock

var block_name := "use block_name to rename"
var block_icon := preload("res://sprites/`missingtexture.png")
var sprite := preload("res://sprites/`missingtexture.png")
var sprite_node

func _ready():
	create_sprite()
	print("modblock created")

func create_sprite():
	sprite_node = Sprite.new()
	sprite_node.set_texture(sprite)
