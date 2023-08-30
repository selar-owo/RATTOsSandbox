extends Node

#player
var mapOn: bool = false
var insideVehicle: bool = false
var noclip:bool = false

#QMENU
var menuCloses: bool = true
var phys: bool = true

#ids
var primary_slot_id := 1
var secondary_slot_id := 0

#tools
var physgunPicking: bool = false
var slot1held := false
var slot2held := false
var slot3held := false
var slot2pic := ""
var slot3pic := ""
var toolGunType:int = 0
var playerTags:Array = []

#old variables
var physEquip: bool = false
var toolGunEquip:bool = false
var pistolEquip:bool = false

#other stuff
var is_paused:bool = false
var does_have_goober := false
var QmenuOpen := false
var camera_zoom := 0.65
var current_tip:String

#version shit
var version_number := [
	"1.1.0" ,#the number
	"The Voted Ones", #the name
	"_beta", #like beta or like aplha
]

#settings
var casing := false
var uitrans := 0.6
#var fpsCounter = true
#var playerSprite
#var glowOn := false
#var musicToggle := false
#var volume:float
#var physColor:Color = Color(0.666667, 0.780392, 1) #0.41,0.83,1
#var show_indicator := true
#var interact_with_physics := false
#var mods := false

func _ready():
	load_mods()

func load_mods():
	var caca = Directory.new()
	if !caca.dir_exists("user://mods/"):
		var fartsghit6 = Directory.new()
		fartsghit6.make_dir("user://mods/")
	print("ok 1")
	
	var files = []
	var dir = Directory.new()
	dir.open("user://mods/")
	dir.list_dir_begin()
	print("ok 2")
	
	while true:
		var file = dir.get_next()
		print(file)
		if file.begins_with("."):
			break
		elif file.ends_with(".pck"):
			print("Pack")
			var success = ProjectSettings.load_resource_pack(str("user://mods/",file),true)
			
			if success:
				print("cacafart8")
			files.append(file)
	print("ok 3")
	
	dir.list_dir_end()

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func go_back_to_main_menu() -> void:
	get_tree().change_scene("res://scenes/UIs/MainMenuNewNew.tscn")
