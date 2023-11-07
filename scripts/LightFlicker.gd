extends Light2D

export var flicker_amount := [0.5,1]

func _process(delta):
	self.energy = rand_range(flicker_amount[0],flicker_amount[1])
