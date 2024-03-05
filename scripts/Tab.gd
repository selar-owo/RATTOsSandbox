extends Node2D

export(Array) var items_in_tab := [
	]
onready var items = $Items

export var auto_load_tab := false
export var auto_open_tab := false

func _ready() -> void:
	if auto_load_tab:
		load_tabs()
	if auto_open_tab:
		open_tab()

func load_tabs():
	print("loading tab")
	var pos := Vector2(-340,-175)
	var move_by := 84
	var current_position := 0
	var current_layer := 0
	for i in items_in_tab:
		var item := preload("res://scenes/ObjectSpawnerItem.tscn").instance()
		var move_vec := Vector2(0,0)
		if current_position >= 8:
			move_vec.y += move_by * (current_layer + 1)
			current_layer += 1
		else:
			move_vec.x += move_by * current_position
		item.block_scene = i["block_scene"]
		item.block_icon = i["block_icon"]
		item.block_name = i["block_name"]
		if i.has("is_path"):
			item.is_path = i["is_path"]
		else:
			item.is_path = true
		items.add_child(item)
		item.rect_position = pos + move_vec
		current_position += 1

func open_tab():
	self.scale = Vector2(0.9,0.9)
	self.modulate.a = 0.2
	self.show()
	var tween_scale := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var tween_modulate := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween_scale.tween_property(self,"scale",Vector2(1,1),0.5)
	tween_modulate.tween_property(self,"modulate:a",1,0.5)
