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
#var slot1held := false
#var slot2held := false
#var slot3held := false
#var slot2pic := ""
#var slot3pic := ""
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
#var camera_zoom := 0.65
var current_tip:String

#version shit
var version_number := [
	"1.1.0" ,#the number
	"Final Touch", #the name
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

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		SaveSettings.save_cfg("VisualsAudio","Fullscreen",!SaveSettings.load_cfg("VisualsAudio","Fullscreen"))
	OS.window_fullscreen = SaveSettings.load_cfg("VisualsAudio","Fullscreen")

func go_back_to_main_menu() -> void:
	get_tree().change_scene("res://scenes/UIs/MainMenuNewNew.tscn")
