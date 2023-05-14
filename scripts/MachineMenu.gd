extends Control

onready var cone: Sprite = $Cone
export var flavors := []
export var cone_type := 0

"""
flavours (in order of them on the scene node thingies)
0 - chocolate
1 - vanilla
2 - strawberry
3 - mint chocolate chip
4 - cookies n' cream
"""

func _process(delta: float) -> void:
	cone_types()
	generate_flavor_sprite()

func generate_flavor_sprite() -> void:
	clear_sprite()
	var pos = -5
	for i in flavors:
		var sprite := Sprite.new()
		cone.add_child(sprite)
		match i:
			0: sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorChocolate.png"))
			1: sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorVanilla.png"))
			2: sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorStrawberry.png"))
			3: sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorMntChocolateChip.png"))
			4: sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorCookiesNCreampng.png"))
		sprite.position.y = pos
		pos -= 3

func clear_sprite() -> void:
	for i in cone.get_children():
		i.queue_free()

func cone_types() -> void:
	match cone_type:
		0:
			cone.set_texture(ResourceLoader.load("res://sprites/IceCreamConeDefault.png"))
		1:
			cone.set_texture(ResourceLoader.load("res://sprites/IceCreamConeSquare.png"))

func _on_Default_button_up() -> void:
	cone_type = 0

func _on_Square_button_up() -> void:
	cone_type = 1

func _on_Chocolate_button_up() -> void:
	flavors.append(0)

func _on_Vanilla_button_up() -> void:
	flavors.append(1)

func _on_Strawberry_button_up() -> void:
	flavors.append(2)

func _on_Mint_Chocolate_Chip_button_up() -> void:
	flavors.append(3)

func _on_Cookies_N_Cream_button_up() -> void:
	flavors.append(4)

func _on_Remove_button_up() -> void:
	flavors.remove(flavors.size() - 1)

func _on_Spawn_button_up() -> void:
	pass # Replace with function body.
