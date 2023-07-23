extends Node2D

onready var transitions = $PopMenus/Transitions
onready var pop_menus = $PopMenus
var can_openorclose := true

func _process(delta):
	if(Input.is_action_just_pressed("move_left")):
		change_menu_state("close")

func change_menu_state(state,changeto = transitions):
	if can_openorclose:
		if(state == "close"):
			transitions.play("GoOut")
		if state == "open":
			hide_all_menus()
			changeto.show()
			transitions.play("GoIn")

func hide_all_menus():
	for i in pop_menus.get_children():
		if !i is AnimationPlayer:
			i.hide()

#buttons
onready var options = $PopMenus/Options

func _on_OptionsButton_pressed():
	change_menu_state("open",options)
