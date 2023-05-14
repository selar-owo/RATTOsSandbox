extends Node2D

onready var volamount:Node = $VolumeAmount
onready var volume_slider:Node = $VolumeSlider
onready var camera:Node = $"../Camera2D"
onready var volSlider:Node = $SliderChanged
onready var file:Node = $FileDialog
onready var filedir:Node = $FileDir

onready var fpsCounter := $FPSCounter
onready var fullscreen := $Fullscreen
onready var glow := $Glow
onready var music_toggle := $MusicToggle
onready var color_pick := $changephysguncolor/PhysPicker
onready var ui_trans := $UItransparency
onready var ui_trans_text := $UIAmount

signal hidePause
signal toggle_mm_song(value)

func _ready():
	loadSettings()

func _process(delta):
	physColor()
	fullscreen.pressed = OS.window_fullscreen
	volamount.text = str(float((Globals.volume/50)*100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Globals.volume)

func physColor():
	$changephysguncolor/heldgun.self_modulate = Globals.physColor
	$changephysguncolor/Physglow.self_modulate = Globals.physColor

func loadSettings():
	volume_slider.value = Globals.volume
	fpsCounter.pressed = Globals.fpsCounter
	fullscreen.pressed = OS.window_fullscreen
	music_toggle.pressed = Globals.musicToggle
	glow.pressed = Globals.glowOn
	color_pick.color = Globals.physColor
	ui_trans.value = Globals.uitrans * 10
	if get_parent().get_name() == "MainMenu":
		emit_signal("toggle_mm_song",Globals.musicToggle)

func _on_Exit_button_up():
	if get_parent().get_name() == "MainMenu":
		camera.position = Vector2(512,300)
	else:
		emit_signal("hidePause")

func _on_VolumeSlider_value_changed(value):
	volSlider.play()
	Globals.volume = volume_slider.value
	print(Globals.volume)

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_Fullscreen2_toggled(button_pressed):
	Globals.fpsCounter = button_pressed

func _on_Glow_toggled(button_pressed):
	Globals.glowOn = button_pressed

func _on_ChangePlayerImage_button_up():
	file.popup(Rect2(file.rect_position,file.rect_size))

func _on_FileDialog_file_selected(path):
	filedir.text = path
	Globals.playerSprite = path

func _on_PhysPicker_color_changed(color):
	Globals.physColor = color

func _on_UItransparency_value_changed(value):
	Globals.uitrans = value / 10
	ui_trans_text.text = str(Globals.uitrans)

func _on_MusicToggle_toggled(button_pressed):
	Globals.musicToggle = button_pressed
	if get_parent().get_name() == "MainMenu":
		emit_signal("toggle_mm_song",button_pressed)
