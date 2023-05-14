extends Particles2D

export(String) var sprite = null

func _ready():
	set_fucking_texture()

func set_fucking_texture():
	$Break.set_texture(ResourceLoader.load(sprite))

func play_break():
	$Break.restart()
