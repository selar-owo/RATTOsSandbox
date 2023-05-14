extends CanvasLayer

onready var player := $"../Player"
onready var keycard_1 = $keycard1
onready var keycard_2 = $keycard2

func _process(delta):
	keycard_inv()

func keycard_inv():
	if player.inventory.has("keycard1"): keycard_1.show()
	else: keycard_1.hide()
	if player.inventory.has("keycard2"): keycard_2.show()
	else: keycard_2.hide()
