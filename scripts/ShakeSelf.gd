extends TextureButton

export var shake_amount := 5
var og_place:Vector2

func _ready():
	og_place = rect_position

func _process(delta):
	rect_position = og_place + Vector2(rand_range(-shake_amount,shake_amount),rand_range(-shake_amount,shake_amount))
	yield(get_tree().create_timer(0.01),"timeout")
