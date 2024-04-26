extends CheckBox

export var section := ""
export var key := ""
export var girlwhat := false
onready var toggjleshejje := [$"../../../../../ToggleOFF",$"../../../../../ToggleON"]

func _ready():
	self.connect("toggled",self,"button_pressed")
	self.pressed = SaveSettings.load_cfg(section,key) 

func _process(delta):
	if girlwhat:
		self.pressed = SaveSettings.load_cfg("VisualsAudio","Fullscreen")

func button_pressed(toggle):
	toggjleshejje[int(self.pressed)].play()
	SaveSettings.save_cfg(section,key,toggle)
