extends SpinBox

export var section := ""
export var key := ""

func _ready():
	self.connect("value_changed",self,"button_used")
	self.value = SaveSettings.load_cfg(section,key)

func button_used(toggle):
	SaveSettings.save_cfg(section,key,toggle)
