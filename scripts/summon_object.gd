extends TextureButton

onready var label:Node = get_node("Label")
onready var objName = get_node(".").get_name()
onready var mouse_pos: Node2D = $"../../../MousePos"
onready var label_that_follow_mouse: Label = $"../../../MousePos/LabelThatFollowMouse"
onready var select_noise:AudioStreamPlayer
var entered:bool = false

func _ready() -> void:
	select_noise = AudioStreamPlayer.new()
	select_noise.set_stream(ResourceLoader.load("res://sounds/hover.wav"))
	self.add_child(select_noise)
	select_noise.volume_db = -40
	rect_pivot_offset = Vector2(38.5,38.5)

func _process(delta: float) -> void:
	mouse_pos.position = get_global_mouse_position()

func _mouse_entered():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"rect_scale",Vector2(1.1,1.1),0.5)
	label_that_follow_mouse.text = label.text.replace("\n"," ")
	select_noise.play()
	mouse_pos.show()

func _mouse_exited():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"rect_scale",Vector2(1,1),0.5)
	mouse_pos.hide()




#the hides
#func _on_woodBlock_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_football_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_bubba_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_thisThing_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_vehicle_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_piston_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_iceCream_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_pussyGame_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_rat_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

#func _on_cheese_button_down():
#	label.hide()
#	rect_scale = Vector2(1,1)

# USE THIS FROM NOW ON
func _on_button_down():
	label.hide()
	rect_scale = Vector2(1,1)
