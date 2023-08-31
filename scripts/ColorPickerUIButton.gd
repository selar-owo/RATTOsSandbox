extends ColorPicker

export var section := ""
export var key := ""

func _ready():
	self.connect("color_changed",self,"color_picked")
	self.color = SaveSettings.load_cfg(section,key) 

func color_picked(colo):
	SaveSettings.save_cfg(section,key,colo)
