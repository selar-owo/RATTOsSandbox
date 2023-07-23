extends Node2D

onready var outline = $Rattos/Sandbox/Outline
onready var rattos = $Rattos

func _process(delta):
	rattos.scale = Vector2(2 + AudioServer.get_bus_effect_instance(3, 0).get_magnitude_for_frequency_range(0, 10000).length(),2 + AudioServer.get_bus_effect_instance(3, 0).get_magnitude_for_frequency_range(0, 10000).length())
