extends Node2D

onready var transitions = $PopMenus/Transitions
onready var pop_menus = $PopMenus
onready var version_number = $VersionNumber

func _ready():
	var is_debug := ""
	if OS.is_debug_build():
		is_debug = "_DEV"
	version_number.text = str("V",Globals.version_number[0],Globals.version_number[2],is_debug," ","(",Globals.version_number[1],")"," ",OS.get_name())
	UniversalWeather.hide()
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and pop_menus.visible:
		change_menu_state("close")

func change_menu_state(state,changeto = transitions):
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
onready var map_selection = $PopMenus/MapSelection

func _on_OptionsButton_pressed():
	change_menu_state("open",options)

func _on_PlayButton_pressed():
	change_menu_state("open",map_selection)

onready var hover = $"../Hover"
onready var select = $"../Select"

func play_sound(zeroforhoverandoneforselect):
	if zeroforhoverandoneforselect == 0:
		hover.play()
	elif zeroforhoverandoneforselect == 1:
		select.play()
