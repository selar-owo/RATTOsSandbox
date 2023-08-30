extends Node2D

onready var main_menu = $"../.."
onready var hover = $"../../../Hover"
onready var select = $"../../../Select"

onready var close = $Close
onready var volume = $Visuals/Volume

onready var slider_sound = $Slider

func _ready():
	load_settings()
	close.connect("mouse_entered",main_menu,"play_sound",[0])

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SaveSettings.load_cfg("VisualsAudio","Volume"))

func load_settings():
	volume.value = SaveSettings.load_cfg("VisualsAudio","Volume")

func _on_Volume_value_changed(value):
	slider_sound.play()
	SaveSettings.save_cfg("VisualsAudio","Volume",value)

func _on_Close_button_up():
	main_menu.change_menu_state("close")
	main_menu.play_sound(1)
