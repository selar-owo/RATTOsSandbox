extends Sprite

var sprites := ["res://sprites/blood decals/blood1.png", "res://sprites/blood decals/blood2.png", "res://sprites/blood decals/blood3.png", "res://sprites/blood decals/blood4.png", "res://sprites/blood decals/blood5.png", "res://sprites/blood decals/blood6.png", "res://sprites/blood decals/blood7.png", "res://sprites/blood decals/blood8.png", "res://sprites/blood decals/blood9.png", "res://sprites/blood decals/blood10.png"]

func _ready() -> void:
	var x = randi() % sprites.size()
	self.set_texture(ResourceLoader.load(sprites[x]))
