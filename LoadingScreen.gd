extends CanvasLayer

var tips := ["be wary of clog","damage hurts","your icon is the player","kill yourself","i just farted","press the play button to begin","opening the menu opens the menu","Urmăriți lacrimile morților","invest in mongolian throat singing","do the thug shaker","start an underground drug market in a low income neighborhood","look around to see your surroundings","performing a blood ritual could lead to an unwanted std","the clown on bad construct is not real","use your cursor to click","you can change your main browser to chrome in settings","-61.28292038, 26.8292749202","delete system34","give me 20 bucks on coinsquirt: liquid finance","shooting something could hurt it","interact to interact","you should screenshare","burger",str("current version is ",Globals.version_number[0]),"awesome sauce","hai",">jfawip walks in"]
onready var tip_label: Label = $TipLabel

func _ready() -> void:
	randomize()
	var x = randi() % tips.size()
	tip_label.text = str("PROTIP: ",tips[x])
	Globals.current_tip = tips[x]
