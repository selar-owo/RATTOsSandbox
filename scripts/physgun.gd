extends StaticBody2D

onready var handler = $HeldItemHandler

onready var player = $"../../.."
onready var physglow = $physglow
onready var physgun_animation_player = $physgunAnimations/AnimationPlayer
onready var physgun_animations = $physgunAnimations
onready var held_sprite_unanim = $heldgun/physgun
onready var held_sprite = $heldgun
onready var light_particles = $physgunAnimations/LightParticles
onready var heavy_particles = $physgunAnimations/HeavyParticles
onready var heavy_particles_2 = $physgunAnimations/HeavyParticles2
onready var glowing_energy = $physgunAnimations/GlowingEnergy
onready var light_2d = $physgunAnimations/GlowingEnergy/Light2D

onready var open = $physgunAnimations/Open
onready var close = $physgunAnimations/Close
onready var loop = $physgunAnimations/Loop

var defopen
var defclose
var defloop

func _ready():
	self.remove_child(physglow)
	defopen = open.volume_db
	defclose = close.volume_db
	defloop = loop.volume_db
	yield(get_tree().create_timer(0.1),"timeout")
	player.root_node.add_child(physglow)

func _process(delta):
	weapon_handler()
	physColor()

func physColor():
	held_sprite.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	physglow.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	light_particles.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	heavy_particles.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	heavy_particles_2.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	glowing_energy.self_modulate = SaveSettings.load_cfg("VisualsAudio","PhysColor")
	light_2d.color = SaveSettings.load_cfg("VisualsAudio","PhysColor")

func weapon_handler():
	if Input.is_action_just_pressed("left_click") and player.slots and player.weapons_allowed:
		physgun_animation_player.play("Open")
	
	if Input.is_action_just_released("left_click") and handler.is_equipped() or handler.is_equipped() and Input.is_action_just_pressed("physbutton") or Input.is_action_just_pressed("pistolbutton") or Input.is_action_just_pressed("toolgunbutton"):
		if player.weapons_allowed:
			physgun_animation_player.play("Close")
	
	if handler.is_equipped():
		open.volume_db = defopen
		close.volume_db = defclose
		loop.volume_db = defloop
	elif !handler.is_equipped():
		open.volume_db = -999
		close.volume_db = -999
		loop.volume_db = -999
	
	if handler.is_equipped():
		physgun_animations.show()
	else:
		physgun_animations.hide()
	
	if Globals.physgunPicking == true and Globals.insideVehicle == false and handler.is_equipped() == true:
		render_line()
		physglow.show()
		physglow.global_position = get_global_mouse_position()
	else:
		physglow.hide()
	
	if handler.is_equipped() == false:
		Globals.physgunPicking = false
	
	if Globals.insideVehicle == true:
		physglow.hide()

func render_line() -> void:
	if !player.old_style:
		var line = Line2D.new()
		player.root_node.add_child(line)
		line.width = 1
		line.z_index = -1
		line.material = preload("res://BulletCanvas.tres")
		line.default_color = SaveSettings.load_cfg("VisualsAudio","PhysColor")
		line.add_point(held_sprite_unanim.global_position)
		line.add_point(get_global_mouse_position())
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(line,"modulate",Color(0,0,0),0.02)
		tween.connect("finished",self,"_delete_line",[line])
