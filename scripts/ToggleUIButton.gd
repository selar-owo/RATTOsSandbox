extends CheckBox

export var section := ""
export var key := ""
export var isfartingeverywhereholyshit := false

func _ready():
	self.connect("toggled",self,"button_pressed")
	self.pressed = SaveSettings.load_cfg(section,key) 

func _process(delta):
	if isfartingeverywhereholyshit:
		self.pressed = SaveSettings.load_cfg("VisualsAudio","Fullscreen")

func button_pressed(toggle):
	SaveSettings.save_cfg(section,key,toggle)
