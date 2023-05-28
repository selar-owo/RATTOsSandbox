extends ColorRect

var iTime = 0

func _process(delta):
	self.material.set("shader_param/time",iTime)
