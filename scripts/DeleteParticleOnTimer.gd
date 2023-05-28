extends Particles2D

export var delete_time := 10.0

func _ready():
	yield(get_tree().create_timer(delete_time),"timeout")
	queue_free()
