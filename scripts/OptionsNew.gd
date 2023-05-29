extends Control

onready var main_menu := $".."
onready var slider_changed = $SliderChanged

onready var main_menu_song = $"../MainMenu"

onready var visuals_and_audio_tab := $VisualsAndAudioTab
onready var physics_and_stuff_tab := $PhysicsAndStuffTab
onready var experimental_tab := $ExperimentalTab
onready var controls = $PhysicsAndStuffTab/Controls

onready var volume_slider = $VisualsAndAudioTab/VolumeSlider
onready var fullscreen = $VisualsAndAudioTab/Fullscreen
onready var show_fps = $VisualsAndAudioTab/ShowFPS
onready var glow = $ExperimentalTab/Glow
onready var show_use_indicator = $VisualsAndAudioTab/ShowUseIndicator
onready var phys_gun_color = $VisualsAndAudioTab/PhysGun/PhysGunColor

onready var littleshits = $VisualsAndAudioTab/PhysGun/Sprite/littleshits
onready var glow_physgun = $VisualsAndAudioTab/PhysGun/Sprite/Glow

onready var interact_with_physics = $ExperimentalTab/InteractWithPhysics
onready var music = $ExperimentalTab/Music
onready var mods = $ExperimentalTab/Mods

signal hidePause

var SHUTTHEFUCKUPDUMBASSSLIDER := true

func _ready():
	open_tab(0)
	loadSettings()
	slider_changed.volume_db = 1.055

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SaveSettings.load_cfg("VisualsAudio","Volume"))

func loadSettings():
	volume_slider.value = SaveSettings.load_cfg("VisualsAudio","Volume")
	show_fps.pressed = SaveSettings.load_cfg("VisualsAudio","ShowFPS")
	fullscreen.pressed = SaveSettings.load_cfg("VisualsAudio","Fullscreen")
	music.pressed = SaveSettings.load_cfg("Experimental","Music")
	glow.pressed = SaveSettings.load_cfg("Experimental","Glow")
	phys_gun_color.color = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	show_use_indicator.pressed = SaveSettings.load_cfg("VisualsAudio","ShowUseIndicator")
	mods.pressed = SaveSettings.load_cfg("Experimental","Mods")
	interact_with_physics.pressed = SaveSettings.load_cfg("Experimental","InteractPhysics")
	
	glow_physgun.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	littleshits.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	
	
	SHUTTHEFUCKUPDUMBASSSLIDER = false
	
	yield(get_tree().create_timer(0.1),"timeout")
	if main_menu is Control:
		main_menu_song.play()

func _on_Exit_button_up() -> void:
	if main_menu is Control:
		main_menu.move_camera(main_menu.default_cam_pos,1)
	else:
		emit_signal("hidePause")

func hide_all_tabs() -> void:
	visuals_and_audio_tab.hide()
	physics_and_stuff_tab.hide()
	experimental_tab.hide()
	controls.hide()

func open_tab(tab) -> void:
	hide_all_tabs()
	if tab == 0:
		visuals_and_audio_tab.show()
	elif tab == 1:
		physics_and_stuff_tab.show()
	elif tab == 2:
		experimental_tab.show()

func _on_VisualsAndAudio_button_up():
	open_tab(0)

func _on_PhysicsAndStuff_button_up():
	open_tab(1)

func _on_Experimental_button_up():
	open_tab(2)

#fucking buttons
func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	SaveSettings.save_cfg("VisualsAudio","Fullscreen",button_pressed)

func _on_ShowFPS_toggled(button_pressed):
	SaveSettings.save_cfg("VisualsAudio","ShowFPS",button_pressed)

func _on_Glow_toggled(button_pressed):
	SaveSettings.save_cfg("Experimental","Glow",button_pressed)

func _on_ShowUseIndicator_toggled(button_pressed):
	SaveSettings.save_cfg("VisualsAudio","ShowUseIndicator",button_pressed)

func _on_PhysGunColor_color_changed(color):
	SaveSettings.save_cfg("VisualsAudio","PhysColor",color)
	glow_physgun.self_modulate = color
	littleshits.self_modulate = color

func _on_InteractWithPhysics_toggled(button_pressed):
	SaveSettings.save_cfg("Experimental","InteractPhysics",button_pressed)

func _on_Music_toggled(button_pressed):
	SaveSettings.save_cfg("Experimental","Music",button_pressed)

func _on_VolumeSlider_value_changed(value):
	SaveSettings.save_cfg("VisualsAudio","Volume",value)
	if !SHUTTHEFUCKUPDUMBASSSLIDER:
		slider_changed.play()

func _on_ControlsButton_button_up():
	controls.visible = !controls.visible

func _on_Mods_toggled(button_pressed):
	SaveSettings.save_cfg("Experimental","Mods",button_pressed)
