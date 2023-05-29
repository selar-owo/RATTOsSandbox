extends Control

onready var main_camera: Camera2D = $Camera2D
onready var options: Control = $Options
onready var map_selection: Node2D = $MapSelection
onready var button_click_animation = $Main/ButtonClickAnimation
onready var version_label = $Version/VersionLabel
var default_cam_pos := Vector2(512,300)

onready var button_press = $ButtonPress
onready var hover = $Hover

onready var mountains := $Decor/MOUNTAINS
onready var bg := $Decor/BG
onready var fg := $Decor/FG

onready var play_button := $Main/Play
onready var options_button := $Main/Options
onready var mods_button := $Main/Mods

func _ready() -> void:
	load_version_number()
	get_tree().paused = false
	UniversalWeather.hide()

func _process(delta):
	move_bg_with_camera()
	mods_button.visible = SaveSettings.load_cfg("Experimental","Mods")

func load_version_number():
	var is_debug := ""
	if OS.is_debug_build():
		is_debug = "_DEV"
	version_label.text = str("V",Globals.version_number[0],Globals.version_number[2],is_debug," ","(",Globals.version_number[1],")"," ",OS.get_name())

func move_bg_with_camera() -> void:
	mountains.position = Vector2(500,700) - (main_camera.offset / 6)
	bg.position = Vector2(500,700) - (main_camera.offset / 4)
	fg.position = Vector2(500,700) - (main_camera.offset / 3)

func move_camera(vec: Vector2,_speed: int = 1) -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(main_camera,"position",vec,_speed)

func _on_Play_button_up() -> void:
	move_camera(Vector2(default_cam_pos.x,-300))
	button_click_animation.play("PlayButton")
	button_press.play()

func _on_Options_button_up() -> void:
	move_camera(Vector2(default_cam_pos.x,900))
	button_click_animation.play("OptionsButton")
	button_press.play()

func _on_Play_mouse_entered():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(play_button,"rect_scale",Vector2(1.6,1.6),0.5)
	tween.play()
	var other_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	other_tween.tween_property(options_button,"rect_scale",Vector2(1.4,1.4),0.5)
	other_tween.play()
	var yet_another_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	yet_another_tween.tween_property(options_button,"modulate",Color(0.7,0.7,0.7),0.5)
	yet_another_tween.play()
	hover.play()

func _on_Options_mouse_entered():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(options_button,"rect_scale",Vector2(1.6,1.6),0.5)
	tween.play()
	var other_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	other_tween.tween_property(play_button,"rect_scale",Vector2(1.4,1.4),0.5)
	other_tween.play()
	var yet_another_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	yet_another_tween.tween_property(play_button,"modulate",Color(0.7,0.7,0.7),0.5)
	yet_another_tween.play()
	hover.play()

func _on_mouse_exited():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(play_button,"rect_scale",Vector2(1.5,1.5),0.5)
	tween.play()
	var other_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	other_tween.tween_property(options_button,"rect_scale",Vector2(1.5,1.5),0.5)
	other_tween.play()
	var yet_another_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	yet_another_tween.tween_property(play_button,"modulate",Color(1,1,1),0.5)
	yet_another_tween.play()
	var selar_try_not_to_make_a_fucking_tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	selar_try_not_to_make_a_fucking_tween.tween_property(options_button,"modulate",Color(1,1,1),0.5)
	selar_try_not_to_make_a_fucking_tween.play()
