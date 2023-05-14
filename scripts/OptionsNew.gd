extends Control

onready var main_menu := $".."
onready var slider_changed = $SliderChanged

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

signal hidePause

func _ready():
	open_tab(0)
	loadSettings()
	slider_changed.volume_db = 1.055

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Globals.volume)

func loadSettings():
	volume_slider.value = Globals.volume
	show_fps.pressed = Globals.fpsCounter
	fullscreen.pressed = OS.window_fullscreen
	music.pressed = Globals.musicToggle
	glow.pressed = Globals.glowOn
	phys_gun_color.color = Globals.physColor
	show_use_indicator.pressed = Globals.show_indicator

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

func _on_ShowFPS_toggled(button_pressed):
	Globals.fpsCounter = button_pressed

func _on_Glow_toggled(button_pressed):
	Globals.glowOn = button_pressed

func _on_ShowUseIndicator_toggled(button_pressed):
	Globals.show_indicator = button_pressed

func _on_PhysGunColor_color_changed(color):
	Globals.physColor = color
	glow_physgun.self_modulate = color
	littleshits.self_modulate = color

func _on_InteractWithPhysics_toggled(button_pressed):
	Globals.interact_with_physics = button_pressed

func _on_Music_toggled(button_pressed):
	Globals.musicToggle = button_pressed

func _on_VolumeSlider_value_changed(value):
	Globals.volume = value
	slider_changed.play()

func _on_ControlsButton_button_up():
	controls.visible = !controls.visible
