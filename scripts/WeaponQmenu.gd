extends Panel

export var weapon_id:int
export var slot_id:int

onready var label_that_follow_mouse = $"../../../../MousePos/LabelThatFollowMouse"
onready var mouse_pos = $"../../../../MousePos"

onready var ui = $"../../../../.."
onready var texture_rect = $TextureRect
onready var select_noise:AudioStreamPlayer

func _ready():
	texture_rect.connect("button_up",self,"_on_press")
	texture_rect.connect("mouse_entered",self,"_on_enter_hover")
	texture_rect.connect("mouse_exited",self,"_on_exit_hover")
	
	select_noise = AudioStreamPlayer.new()
	select_noise.set_stream(ResourceLoader.load("res://sounds/hover.wav"))
	self.add_child(select_noise)
	select_noise.volume_db = -40
	rect_pivot_offset = Vector2(38.5,38.5)

func _on_enter_hover() -> void:
	select_noise.play()
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"rect_scale",Vector2(1.1,1.1),0.5)
	label_that_follow_mouse.text = self.get_name().replace("\n"," ")
	select_noise.play()
	mouse_pos.show()

func _on_exit_hover() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"rect_scale",Vector2(1,1),0.5)
	mouse_pos.hide()

func _on_press() -> void:
	if slot_id == 0:
		Globals.primary_slot_id = weapon_id
	elif slot_id == 1:
		Globals.secondary_slot_id = weapon_id
	
	ui.player.setup_weapons()
	ui.setup_UI_pic()
