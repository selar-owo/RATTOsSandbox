extends Node2D

onready var mapSelMen = get_node("MapSelection")
onready var camera = $Camera2D
onready var tween = $Tween
onready var press_sound := $ButtonPress
onready var hover_sound := $Hover
onready var version_number := $Main/versionnum
const fart = preload("res://sprites/fart.png")

func _ready():
	get_tree().paused = false
	supersecrettitle()
	load_version_number()
	UniversalWeather.hide()

func _process(delta):
	go_back_a_fuckin_page_bitch()

func go_back_a_fuckin_page_bitch():
	if Input.is_action_just_pressed("pause"):
		camera.position = Vector2(512,300)

func load_version_number():
	var is_debug := ""
	if OS.is_debug_build():
		is_debug = "_DEV"
	version_number.text = str("V",Globals.version_number[0],Globals.version_number[2],is_debug," ","(",Globals.version_number[1],")"," ",OS.get_name())

func supersecrettitle():
	randomize()
	if round(rand_range(1,1000000)) == 1: #1000000
		$Main/TitleReal/Shadow/Title.set_texture(fart)
		$Main/TitleReal/Shadow.set_texture(fart)

func _on_play_button_up():
	press_sound.play()
	camera.position.y = -300
	camera.position.x = 512

func _on_options_button_up():
	press_sound.play()
	camera.position.y = 900
	camera.position.x = 512

func _on_mods_button_up():
	press_sound.play()
	camera.position.y = 300
	camera.position.x = 1612

func _on_multiplayer_button_up():
	camera.position.x = 1612

func _on_Twitter_button_up():
	camera.position = Vector2(-513,-300)

func _on_Youtube_button_up():
	OS.shell_open("https://www.youtube.com/@justshitmyself")

func _on_LinkButton_button_up():
	OS.shell_open("https://discord.gg/bCaKHHEuSv")

#funny tween
const select_big_size = 1.8
const select_small_size = 1.6
const dark_color = 0.4
const duration = 0.3

const default_button_size = 1.7

func _on_play_mouse_entered():
	hover_sound.play()
	tween.interpolate_property($Main/play,"rect_scale",$Main/play.rect_scale,Vector2(select_big_size,select_big_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/options,"rect_scale",$Main/options.rect_scale,Vector2(select_small_size,select_small_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/options,"modulate",$Main/options.modulate,Color(dark_color,dark_color,dark_color),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()

func _on_options_mouse_entered():
	hover_sound.play()
	tween.interpolate_property($Main/options,"rect_scale",$Main/options.rect_scale,Vector2(select_big_size,select_big_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/play,"rect_scale",$Main/play.rect_scale,Vector2(select_small_size,select_small_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/play,"modulate",$Main/play.modulate,Color(dark_color,dark_color,dark_color),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()

func _on_mouse_exited():
	tween.interpolate_property($Main/options,"modulate",$Main/options.modulate,Color(1,1,1),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/play,"modulate",$Main/play.modulate,Color(1,1,1),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/play,"rect_scale",$Main/play.rect_scale,Vector2(default_button_size,default_button_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property($Main/options,"rect_scale",$Main/options.rect_scale,Vector2(default_button_size,default_button_size),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()

func _on_Options_toggle_mm_song(value):
	pass
#	$MainMenu.playing = value
