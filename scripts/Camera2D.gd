extends Camera2D

func _process(delta):
	var distance = lerp(self.position,self.position - get_local_mouse_position(),0.05)
	self.offset = self.position - distance
