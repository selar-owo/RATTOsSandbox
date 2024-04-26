extends Node2D

export var pos1:Vector2
export var pos2:Vector2
export var flower_amount_range := [10,30]

const COMMON_FLOWERS := [preload("res://sprites/foliage/commonFlower1.png"), preload("res://sprites/foliage/commonFlower2.png"), preload("res://sprites/foliage/commonFlower3.png")]
const UNCOMMON_FLOWERS := [preload("res://sprites/foliage/uncommonFlower1.png"), preload("res://sprites/foliage/uncommonFlower2.png"), preload("res://sprites/foliage/uncommonFlower3.png")]
const RARE_FLOWERS := [preload("res://sprites/foliage/rareFlower1.png"), preload("res://sprites/foliage/rareFlower2.png"), preload("res://sprites/foliage/rareFlower3.png"),preload("res://sprites/foliage/rareFlower4.png")]

func _ready():
	print("setting up flowers")
	for i in round(rand_range(flower_amount_range[0],flower_amount_range[1])):
		var roll := rand_range(0,100)
		var flower_sprite
		if roll < 50:
			flower_sprite = COMMON_FLOWERS[randi() % COMMON_FLOWERS.size()]
		elif roll >= 50 and roll < 90:
			flower_sprite = UNCOMMON_FLOWERS[randi() % UNCOMMON_FLOWERS.size()]
		elif roll >= 90:
			flower_sprite = RARE_FLOWERS[randi() % RARE_FLOWERS.size()]
		
		var flower := Sprite.new()
		flower.set_texture(flower_sprite)
		flower.scale = Vector2(1.5,1.5)
		flower.rotation_degrees = rand_range(-360,360)
		self.add_child(flower)
		flower.global_position = Vector2(rand_range(pos1.x,pos2.x),rand_range(pos1.y,pos2.y))
	print("done spawning flowers")
