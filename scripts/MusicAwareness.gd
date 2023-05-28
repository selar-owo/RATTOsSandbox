extends Node2D

onready var transitions = $"../Transitions"
var is_enemies := true
var played := false

func _process(delta):
	if is_enemies:
		transitions.play("CalmToCombat")
	elif !is_enemies:
		transitions.play("CombatToCalm")
