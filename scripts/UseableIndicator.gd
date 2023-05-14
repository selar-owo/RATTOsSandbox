extends Node2D
#old transparency = 128
#new transparency = 40
export(Vector2) var hitbox_size := Vector2(8,8)
export(Vector2) var hitbox_position := Vector2(0,0)
onready var hitbox := $Area2D/CollisionShape2D
onready var tween := $Tween
onready var sprite := $Sprite
var default_scale := 0.25
var time := 0.3

func _ready():
	hitbox.shape.extents = hitbox_size
	tween.interpolate_property($Sprite,"scale",$Sprite.scale,Vector2(0,0),time,Tween.TRANS_QUART,Tween.EASE_OUT)
	tween.start()

func _process(delta):
	global_rotation_degrees = 0

func _on_Area2D_area_entered(area):
	if area.get_name() == "intArea":
		tween.interpolate_property($Sprite,"scale",$Sprite.scale,Vector2(default_scale,default_scale),time,Tween.TRANS_BACK,Tween.EASE_OUT)
		tween.start()

func _on_Area2D_area_exited(area):
	if area.get_name() == "intArea":
		tween.interpolate_property($Sprite,"scale",$Sprite.scale,Vector2(0,0),time,Tween.TRANS_QUART,Tween.EASE_OUT)
		tween.start() 

func _on_Area2D_mouse_entered():
	tween.interpolate_property($Sprite,"modulate",$Sprite.modulate,Color(1.6,1.6,1.6),time,Tween.TRANS_QUART,Tween.EASE_OUT)
	tween.start() 

func _on_Area2D_mouse_exited():
	tween.interpolate_property($Sprite,"modulate",$Sprite.modulate,Color(1,1,1),time,Tween.TRANS_QUART,Tween.EASE_OUT)
	tween.start() 
