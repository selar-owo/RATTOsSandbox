extends Node2D

onready var main_menu = $"../.."
onready var hover = $"../../../Hover"
onready var select = $"../../../Select"

onready var buttons = $Buttons
onready var visuals_button = $Buttons/Visuals
onready var physics_button = $Buttons/Physics
onready var experiments_button = $Buttons/Experiments

onready var close = $Close
onready var volume = $Visuals/Volume
onready var health_bar_style = $Visuals/HealthBarStyle

onready var slider_sound = $Slider

func _ready():
	load_settings()
	close.connect("mouse_entered",main_menu,"play_sound",[0])
	visuals_button.connect("button_up",self,"open_tab",[$Visuals,visuals_button])
	physics_button.connect("button_up",self,"open_tab",[$Physics,physics_button])
	experiments_button.connect("button_up",self,"open_tab",[$Experimental,experiments_button])

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SaveSettings.load_cfg("VisualsAudio","Volume"))

func hide_all_tabs():
	$Visuals.hide()
	$Physics.hide()
	$Experimental.hide()
	for button in buttons.get_children():
		var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(button,"rect_position:y",101.0,1)
		tween.play()

func open_tab(tab,button):
	hide_all_tabs()
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(button,"rect_position:y",95.0,1)
	tween.play()
	tab.show()

func load_settings():
	health_bar_style.add_item("plus")
	health_bar_style.add_item("bar")
	health_bar_style.add_item("number")
	health_bar_style.add_item("heart")
	
	volume.value = SaveSettings.load_cfg("VisualsAudio","Volume")

func _on_Volume_value_changed(value):
	slider_sound.play()
	SaveSettings.save_cfg("VisualsAudio","Volume",value)

func _on_Close_button_up():
	main_menu.change_menu_state("close")
	main_menu.play_sound(1)
