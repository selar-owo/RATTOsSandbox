extends AudioStreamPlayer

onready var music_cooldown := $Timer
var default_db:float
var songs := [
	"res://sounds/ost/birdsong.mp3",
	"res://sounds/ost/SandboxianBackgroundOST_1.mp3",
	"res://sounds/ost/stupidfuckinganothersongidk_the_midlde_part_is_cool_tho.mp3"
]

func _ready():
	music_cooldown.start()
	default_db = self.volume_db

func _process(delta):
	ithinkipoopedalittle()


func ithinkipoopedalittle():
	if default_db != null:
		if !Globals.musicToggle:
			self.volume_db = -3412348213210391
		elif Globals.musicToggle:
			self.volume_db = default_db

func select_random_song():
	var x := randi() % songs.size()
	var thefunny := load(songs[x])
	self.stream = thefunny
	self.play()

func _on_Music_finished():
	if self.playing == false:
		randomize()
		music_cooldown.wait_time = rand_range(5,10)
		music_cooldown.start()
	else:
		music_cooldown.start()

func _on_Timer_timeout():
	if self.playing == false:
		select_random_song()
	else:
		music_cooldown.start()
