extends OptionButton

export var section := ""
export var key := ""

func _ready():
	var cacart
	match SaveSettings.load_cfg(section,key):
		"plus": cacart = 0
		"bar": cacart = 1
		"number": cacart = 2
		"heart": cacart = 3
	self.connect("item_selected",self,"button_used")
	yield(get_tree().create_timer(0.1),"timeout")
	self._select_int(self.get_item_index(cacart))

func button_used(option):
	var fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o
	match option:
		0: fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o = "plus"
		1: fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o = "bar"
		2: fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o = "number"
		3: fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o = "heart"
	SaveSettings.save_cfg(section,key,fartshw214213ji2i4j3i2pu4302i4ui032urio32uri0o)
