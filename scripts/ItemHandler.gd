extends Node

export var path_item:NodePath
export var id:int
var item
var current_slot:int

func _ready() -> void:
	anchor()
	yield(get_tree().create_timer(0.01),"timeout")
	item.player.slots[current_slot]["id"] = id
	print(current_slot)

func anchor() -> void:
	current_slot = int(self.get_parent().get_parent().name.replace("Slot",""))
	item = get_node(path_item)

func is_equipped() -> bool:
	return item.player.slots[current_slot]["isheld"]
