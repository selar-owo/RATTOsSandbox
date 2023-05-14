extends Node2D

onready var mapCam:Node = get_node("Camera2D")
onready var worldenv:Node = get_node_or_null("WorldEnvironment")
onready var objectFolder:Node = $Objects
onready var inGameObjectFolder:Node = $IngameObjects
onready var player: KinematicBody2D = $Player
onready var sexbutton: RigidBody2D = $IngameObjects/sexbutton
onready var fire: Sprite = $UI/Fire
onready var calm_song: AudioStreamPlayer = $Calm
onready var combat_song: AudioStreamPlayer = $Combat
onready var navigation_2d: Navigation2D = $Navigation2D
#-60

var cooldown_started
export var sex_mode := false
export var darkness:Color = Color(1,1,1)
export var combat_map := false
export var in_combat := false
var sex_spawned := false

func _ready():
	$Player.health = 100
	agoodfunctionname()
	Globals.mapOn = false
	UniversalWeather.color = darkness
	UniversalWeather.show()

func _process(delta):
	map()
	settingsUpdate()
	SEX_MODE_FUNCTION()
	combat_music()
#	if Input.is_action_just_pressed("left_click"):
#		var x = preload("res://scenes/otherstuffidk/Explosion.tscn").instance()
#		x.position = get_global_mouse_position()
#		x.explosion_size = Vector2(4,4)
#		x.explosion_damage = 200
#		self.add_child(x)

func combat_music() -> void:
	if combat_map:
		var tween_calm := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		var tween_combat := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		if in_combat and combat_song.volume_db == -60:
			tween_calm.tween_property(calm_song,"volume_db",-60.0,2)
			tween_combat.tween_property(combat_song,"volume_db",-20.0,1)
			tween_calm.play()
			tween_combat.play()
		elif !in_combat and calm_song.volume_db == -60:
			tween_combat.tween_property(combat_song,"volume_db",-60.0,2)
			tween_calm.tween_property(calm_song,"volume_db",-20.0,1)
			tween_calm.play()
			tween_combat.play()
		var is_enemies := false
		for i in navigation_2d.get_children():
			if i.is_class("KinematicBody2D"):
				in_combat = true
				is_enemies = true
		if is_enemies == false:
			in_combat = false

func SEX_MODE_FUNCTION() -> void:
	if sex_mode:
		player.camera_shake(5,1)
		UniversalWeather.color = Color(0.5,0,0)
		if !sex_spawned:
			fire.show()
			$UI/SoCool/P2CerebrusNoise.play()
			$Ambience.volume_db = -4014010421
			player.change_camera_zoom(Vector2(0.4,0.4),Tween.EASE_OUT,1)
			for _i in range(100):
				var whiteout = preload("res://scenes/boss/minions/SoCoolMinion.tscn").instance()
				whiteout.position = sexbutton.position + Vector2(rand_range(-400,400),rand_range(-400,400))
				$Navigation2D.add_child(whiteout)
			sex_spawned = true

func agoodfunctionname():
	if Globals.does_have_goober:
		var meatboy = preload("res://scenes/mobs/MeatBoy.tscn").instance()
		inGameObjectFolder.add_child(meatboy)

func settingsUpdate():
	if worldenv != null:
		worldenv.environment.glow_enabled = Globals.glowOn

func map():
	mapCam.current = Globals.mapOn
