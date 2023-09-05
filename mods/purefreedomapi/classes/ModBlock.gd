extends RigidBody2D
class_name ModBlock

var block_name := "use block_name to rename"
var block_icon := preload("res://sprites/`missingtexture.png")
var block_sprite := preload("res://sprites/`missingtexture.png")

var sprite
var collisionbox
var area_2d
var area_2d_collisionbox

func _ready():
	setup_nodes()

func setup_nodes():
	sprite = Sprite.new()
	collisionbox = CollisionShape2D.new().set_shape(RectangleShape2D.new().set_extents(Vector2(8,8)))
	area_2d_collisionbox = CollisionShape2D.new().set_shape(RectangleShape2D.new().set_extents(Vector2(8,8)))
	area_2d = Area2D.new().add_child(area_2d_collisionbox)
	self.add_child(sprite)
	self.add_child(collisionbox)
	self.add_child(area_2d)
	sprite.set_texture(block_sprite)
	self.name = block_name
	print("setup ",self.get_name())
