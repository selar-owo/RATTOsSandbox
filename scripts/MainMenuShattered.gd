extends Control

onready var main_camera = $Camera2D
var default_cam_pos := Vector2(512,300)

onready var button_press = $ButtonPress
onready var hover = $Hover
onready var main_menu = $MainMenu

onready var fight_me_text = $FightMeText
onready var so_cool = $Decor/SoCool

onready var button_click_animation = $Main/ButtonClickAnimation
onready var fades = $Fades

func _ready():
	so_cool.rect_pivot_offset = (so_cool.rect_size * so_cool.rect_scale) / 5

func _process(delta):
	fight_me_text.position = get_global_mouse_position()

func move_camera(vec: Vector2,_speed: int = 1) -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(main_camera,"position",vec,_speed)

func _on_Play_button_up():
	move_camera(Vector2(default_cam_pos.x,-300),2)
	button_click_animation.play("PlayButton")
	button_press.play()

func _on_Play_mouse_entered():
	hover.play()

func _on_MapTile_mouse_entered():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(so_cool,"rect_scale",Vector2(3.6,3.6),0.5)
	hover.play()
	fight_me_text.show()

func _on_MapTile_mouse_exited():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(so_cool,"rect_scale",Vector2(3,3),0.5)
	fight_me_text.hide()

func _on_SoCool_button_up():
	main_menu.stop()
	button_press.play()
	so_cool.disabled = true
	fades.play("FadeOut")
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	var tween_red := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween_red.tween_property(so_cool,"modulate",Color(6,0.5,0.5),3)
	tween.tween_property(main_camera,"zoom",Vector2(0,0),3)

func _on_Fades_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene_to(ResourceLoader.load("res://scenes/Maps/AllInOne.tscn"))
