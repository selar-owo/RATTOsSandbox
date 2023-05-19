extends CanvasLayer

onready var bar:Node = get_node("HealthBarShiz/HealthBar")
onready var barlab:Node = get_node("HealthBarShiz/HealthBarLabel")
onready var QMenuObj:Node = get_node("QMenu")
onready var objectFolder:Node = get_node("../Objects")
onready var fps:Node = get_node("FPS")
onready var physbut:Node = get_node("toolselection/physgun")
onready var Blocks:Node = get_node("QMenu/Items/Blocks")
onready var Mobs:Node = get_node("QMenu/Items/Mobs")
onready var Useable:Node = get_node("QMenu/Items/Interactable")
onready var funny:Node = get_node("QMenu/Items/funny")
onready var Weapons := $QMenu/Items/Weapons
onready var menuClosesButton:Node = get_node("QMenu/Options/menuCloses")
onready var Physics:Node = get_node("QMenu/Options/Physics")
onready var buttonanim:Node = $QMenu/backBox/AnimationPlayer
onready var buttonspr:Node = $QMenu/backBox
onready var tween:Node = $Tween
onready var console:Node = $Console
onready var console_text_edit: TextEdit = $Console/TextEdit
onready var console_line_edit: LineEdit = $Console/debug
onready var player := $"../Player"
onready var bottomback := $bg1
onready var shieldbar := $HealthBarShiz/ShieldBar
onready var root_node: Node2D = $".."

onready var butBlocks:Node = get_node("QMenu/Blocks")
onready var butMobs:Node = get_node("QMenu/Mobs")
onready var butUseable:Node = get_node("QMenu/Interactable")
onready var butFunny:Node = get_node("QMenu/Funny")

onready var pause_menu:Node = $Pause

onready var tagLines:Node = $QMenu/Options/addTag/tags
onready var tagInput:Node = $QMenu/Options/addTag/LineEdit
onready var optionsMenu:Node = $Pause/Options
onready var pauseMenu:Node = $Pause/PauseMenuReal
onready var start_transition_anim_obj := $Transitionsandshit/going_in/AnimationPlayer
onready var start_transition_obj := $Transitionsandshit/going_in
onready var hurt_animation: AnimationPlayer = $HealthBarShiz/HurtAnimation
onready var camera_2d: Camera2D = $"../Player/Camera2D"
onready var close_to_death: Sprite = $CloseToDeath
onready var parry_thing: ColorRect = $ParryThing
onready var parry_timer: Timer = $ParryTimer
onready var parry_noise: AudioStreamPlayer = $ParryNoise
onready var parry_anim: AnimationPlayer = $ParryAnim
onready var slot_1_background: Panel = $toolselection/physgun/slot1background
onready var slot_2_background: Panel = $toolselection/slot2/slot2background
onready var slot_3_background: Panel = $toolselection/slot3/slot3background

onready var slot2sprite := $toolselection/slot2
onready var slot3sprite := $toolselection/slot3

var QmenuBlocks := [
	"res://scenes/blocks/woodBlock.tscn",
	"res://scenes/blocks/iceBlock.tscn",
	"res://scenes/blocks/brick.tscn",
	"res://scenes/blocks/steelBlock.tscn",
	"res://scenes/blocks/reinforcedSteelBlock.tscn",
]

onready var keycard_1: Sprite = $Keycard1
onready var keycard_2: Sprite = $Keycard2
onready var keycard_3: Sprite = $Keycard3

var optionsOn:bool = false
var debugON:bool = false
var paused:bool = false
var ftodart := false
var console_help := """summon_object (object) - summons an object. path starts from the scene path
help - you dont need help with this one
reload_map - reloads the current map
switch_map (map) - switchs to that map. path starts from the Maps folder
clear - clears the console
change_player_texture (file_prompt) - opens a file prompt to change the player texture
tp (x,y) - toilet paper
change_weapon (id,slot) - just do (help weapon_ids) for the ids
update_weapons - updates weapons
quit - quits
"""
#export(bool) var QmenuOpen:bool = false
export(bool) var start_transition := true
export(bool) var console_allowed := true

func setup_UI_pic():
	if Globals.slot2pic != "":
		slot2sprite.set_normal_texture(ResourceLoader.load(Globals.slot2pic))
	if Globals.slot3pic != "":
		slot3sprite.set_normal_texture(ResourceLoader.load(Globals.slot3pic))

func move_with_cursor() -> void:
	self.offset = lerp(camera_2d.offset,(self.offset - camera_2d.position * -1),0.001) / 10

func parry() -> void:
	parry_thing.show() #0.19
	parry_timer.start()
	parry_noise.play()
	parry_anim.play("Parry")

func show_keycard(keycard_id) -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	match keycard_id:
		1:
			keycard_1.show()
			tween.tween_property(keycard_1,"position:y",569.0,1)
		2:
			keycard_2.show()
			tween.tween_property(keycard_2,"position:y",569.0,1)
		3:
			keycard_3.show()
			tween.tween_property(keycard_3,"position:y",569.0,1)
	tween.play()
func _ready():
	Globals.QmenuOpen = false
	kriz_vrigly_dirgly()
	setup_UI_pic()
	QMenuObj.position.y = -540
	buttonspr.rect_position = Vector2(31,23)
	buttonspr.rect_size = Vector2(115,47)
	loadQMENUsettings()
	
	if start_transition:
		start_transition_obj.show()
		start_transition_anim_obj.play("CumIn")
	
	hide_qmenu_items()
	Blocks.show()
	
	player.connect("damaged",self,"_on_hurt")

func vignette_death_thing() -> void:
	var amount = float(1 - player.health/100)
	print(amount,"-",close_to_death.modulate.a)
	close_to_death.modulate.a = float(amount)

func _on_hurt() -> void:
	hurt_animation.seek(0.0,true)
	hurt_animation.play("Hurt")

func loadQMENUsettings():
	var phystog = $QMenu/Options/Physics
	var menutog = $QMenu/Options/menuCloses
	
	phystog.pressed = Globals.phys
	menutog.pressed = Globals.menuCloses

func _process(delta):
	health_bar()
	QMenu()
	fpsCounter(delta)
	pause_screen()
	ui_trans_option()
	kriz_shut_the_fuck_up_omg_you_jojo_fag()
	move_with_cursor()
	selected()
	if console_line_edit.has_selection() or console_line_edit.has_focus():
		player.movement_allowed = false
		player.teleport_allowed = false
		player.set_process_input(false)
		player.set_process_unhandled_key_input(false)
		player.set_process_unhandled_input(false)
	elif !console_line_edit.has_selection() or !console_line_edit.has_focus():
		player.movement_allowed = true
		player.teleport_allowed = true
		player.set_process_input(true)
		player.set_process_unhandled_key_input(true)
		player.set_process_unhandled_input(true)
	
	if Input.is_action_just_pressed("console") and console_allowed: console.visible = !console.visible

func selected() -> void:
	if Globals.slot1held: slot_1_background.modulate = Color(2,2,2,0.39)
	elif !Globals.slot1held: slot_1_background.modulate = Color(1,1,1,0.39)
	if Globals.slot2held: slot_2_background.modulate = Color(2,2,2,0.39)
	elif !Globals.slot2held: slot_2_background.modulate = Color(1,1,1,0.39)
	if Globals.slot3held: slot_3_background.modulate = Color(2,2,2,0.39)
	elif !Globals.slot3held: slot_3_background.modulate = Color(1,1,1,0.39)

func kriz_vrigly_dirgly():
	if Globals.does_have_goober:
		ftodart = true

func kriz_shut_the_fuck_up_omg_you_jojo_fag():
	if ftodart and Globals.does_have_goober:
		$sex.show()
	else:
		$sex.hide()
		return
	if Input.is_action_just_pressed("creature_dash"):
		ftodart = false
		return

func ui_trans_option():
	bottomback.modulate.a = Globals.uitrans

func pause_screen():
	var options_open
	
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		optionsOn = false
		if paused:
			get_tree().paused = true
			pause_menu.show()
			tween.interpolate_property(pause_menu,"modulate:a",pause_menu.modulate.a,1,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
		else:
			$WhatTheFuckIsATag.interpolate_property(pause_menu,"modulate:a",pause_menu.modulate.a,0,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
			get_tree().paused = false
		tween.start()
		$WhatTheFuckIsATag.start()
	
#	pause_menu.visible = paused
	pauseMenu.visible = !optionsOn
	optionsMenu.visible = optionsOn

func fpsCounter(delta):
	if Globals.fpsCounter == true:
		fps.text = str(round(1 / delta))
		fps.show()
	else:
		fps.hide()

func hide_qmenu_items():
	Blocks.hide()
	Mobs.hide()
	Useable.hide()
	funny.hide()
	Weapons.hide()

func health_bar():
	var player_shield = player.health - 100
	shieldbar.value = lerp(shieldbar.value,player_shield,0.8)
	bar.value = lerp(bar.value,player.health,0.8)
	barlab.text = str(round(player.health))

func change_qmenu_state(state):
	if state:
		tween.interpolate_property(QMenuObj,"position:y",QMenuObj.position.y,0,0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	else:
		tween.interpolate_property(QMenuObj,"position:y",QMenuObj.position.y,-540,0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	tween.start()

func QMenu():
	if Input.is_action_just_pressed("QMenu") and player.qmenu_allowed:
		Globals.QmenuOpen = !Globals.QmenuOpen
		
		if Globals.QmenuOpen:
			change_qmenu_state(true)
		else:
			change_qmenu_state(false)

func _on_physgun_button_up():
	Globals.slot1held = !Globals.slot1held
	Globals.slot3held = false
	Globals.slot2held = false

func _on_gun_button_up():
	Globals.slot2held = !Globals.slot2held
	Globals.slot3held = false
	Globals.slot1held = false

func _on_slot3_button_up():
	Globals.slot3held = !Globals.slot3held
	Globals.slot1held = false
	Globals.slot2held = false

#all the fuckaing bocks

func summonBlock(blockString):
	if Globals.menuCloses == true:
		Globals.QmenuOpen = false
		change_qmenu_state(false)
	var block = load(blockString).instance()
	objectFolder.add_child(block)

func _on_woodBlock_button_down():
	summonBlock("res://scenes/blocks/woodBlock.tscn")

func _on_football_button_down():
	summonBlock("res://scenes/blocks/football.tscn")

func _on_bubba_button_down():
	summonBlock("res://scenes/funny/bumba.tscn")

func _on_thisThing_button_down():
	summonBlock("res://scenes/funny/TheBITCH!!!!.tscn")

func _on_vehicle_button_down():
	summonBlock("res://scenes/cars/car.tscn")

func _on_piston_button_down():
	summonBlock("res://scenes/blocks/piston.tscn")

func _on_iceCream_button_down():
	summonBlock("res://scenes/useables/IceCreamMachine.tscn")

func _on_pussyGame_button_down():
	summonBlock("res://scenes/useables/pussyGame.tscn")

func _on_rat_button_down():
	summonBlock("res://scenes/mobs/rat.tscn")

func _on_cheese_button_down():
	summonBlock("res://scenes/blocks/cheese.tscn")

func _on_thisThing2_button_down():
	summonBlock("res://scenes/funny/bobm.tscn")

func _on_MESSI_button_down():
	summonBlock("res://scenes/blocks/Radio.tscn")

func _on_iceBlock_button_down():
	summonBlock("res://scenes/blocks/iceBlock.tscn")

func _on_brick_button_down():
	summonBlock("res://scenes/blocks/brick.tscn")

func _on_steelBlock_button_down():
	summonBlock("res://scenes/blocks/steelBlock.tscn")

func _on_reinforcedSteelBlock_button_down():
	summonBlock("res://scenes/blocks/reinforcedSteelBlock.tscn")

func _on_goal_button_down():
	summonBlock("res://scenes/blocks/goal.tscn")

func _on_ratsentry_button_down() -> void:
	summonBlock("res://scenes/mobs/ratSentry.tscn")

#qmenu button

func tween_qmenu_select(type,pos_x,scale_x):
	var tween_time := 0.5
	type.show()
	tween.interpolate_property(buttonspr,"rect_position:x",buttonspr.rect_position.x,pos_x,tween_time,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.interpolate_property(buttonspr,"rect_size:x",buttonspr.rect_size.x,scale_x,tween_time,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()

func _on_Blocks_button_up():
	hide_qmenu_items()
	tween_qmenu_select(Blocks,31,115)

func _on_Mobs_button_up():
	hide_qmenu_items()
	tween_qmenu_select(Mobs,151,84)

func _on_Interactable_button_up():
	hide_qmenu_items()
	tween_qmenu_select(Useable,245,135)

func _on_Funny_button_up():
	hide_qmenu_items()
	tween_qmenu_select(funny,385,131)

func _on_Weapons_button_up():
	hide_qmenu_items()
	tween_qmenu_select(Weapons,527,132)

#idk
#func _on_menuCloses_button_up():
#	Globals.menuCloses = !Globals.menuCloses
#	if Globals.menuCloses == true:
#		menuClosesButton.texture_normal = load("res://sprites/on.png")
#	else:
#		menuClosesButton.texture_normal = load("res://sprites/off.png")
#
#func _on_Physics_button_up():
#	Globals.phys = !Globals.phys
#	if Globals.phys == true:
#		Physics.texture_normal = load("res://sprites/on.png")
#	else:
#		Physics.texture_normal = load("res://sprites/off.png")

func _on_undo_button_up():

	var childrenAmount = -1
	
	for n in objectFolder.get_children():
		childrenAmount += 1
	
	if childrenAmount >= 0:
		if objectFolder.get_child(childrenAmount).get_child(0).get_name() == "vehicle":
			Globals.insideVehicle = false
		print("Deleted ",objectFolder.get_child(childrenAmount))
		objectFolder.get_child(childrenAmount).queue_free()

func _on_deleteall_button_up():
	for n in objectFolder.get_children():
		Globals.insideVehicle = false
		n.queue_free()
		yield(get_tree().create_timer(0.001), "timeout")


func _on_LineEdit_text_entered(new_text):
#	var input = new_text
#
#	if input != "":
#		print("Adding Tag: ", input)
#		tagLines.text += str("\n", input)
#		Globals.playerTags += [input]
#		print(Globals.playerTags)
	
	tagInput.clear()

func console_add_line(line,is_error = false) -> void:
	if console_text_edit != null:
		if !is_error:
	#		console_text_edit.add_color_override("font_color_readonly",Color(0.5,0.5,0.5))
			console_text_edit.text += str("\n",line)
		elif is_error:
	#		console_text_edit.add_color_override("font_color_readonly",Color(1,0.5,0.5))
			console_text_edit.add_color_region("ERROR",".",Color(1,0.5,0.5),true)
			console_text_edit.text += str("\n","ERROR: ",line)

func console_line_entered(text:String) -> void:
	if text != "" or text != " ":
		var command := text.split(" ",false)[0]
		var prompt_1
		var prompt_2
		if text.split(" ",false).size() != 1:
			prompt_1 = text.split(" ",false)[1]
		if text.split(" ",false).size() > 2:
			prompt_2 = text.split(" ",false)[2]
		
		if command == "summon_object":
			var block := str("res://scenes/",prompt_1,".tscn")
			var check_file = File.new().file_exists(block)
			if check_file:
				var block_instance = ResourceLoader.load(block).instance()
				block_instance.position = player.position
				objectFolder.add_child(block_instance)
				console_add_line(str("Added block ",block))
			elif !check_file:
				console_add_line(str(block," is not a vaild object path!"),true)
		
		elif command == "switch_map":
			var scene := str("res://scenes/Maps/",prompt_1,".tscn")
			var check_file = File.new().file_exists(scene)
			if check_file:
				console_add_line(str("Switching map to ",scene," (if you have the time to read this it means it didnt load)"))
				get_tree().change_scene(scene)
			elif !check_file:
				console_add_line(str(scene," is not a vaild map path!"),true)
		
		elif command == "help":
			if prompt_1 == null:
				console_add_line(console_help)
			elif prompt_1 == "weapon_ids":
				console_add_line("""-list of all weapon ids-
0 - pistol (sec)
1 - assault rifle (prim)
2 - shotgun (prim)
3 - revolver (sec)
4 - bazooka (prim)
5 - terrablade (prim)""")
		
		elif command == "reload_map":
			console_add_line("Reset map.")
			get_tree().reload_current_scene()
		elif command == "clear":
			for i in console_text_edit.get_line_height():
				console_text_edit.undo()
		elif command == "quit":
			get_tree().quit()
		elif command == "change_player_texture":
			$Console/FileDialog.popup_centered()
			console_add_line("Opened Dialog.")
		elif command == "tp":
			if prompt_1 == null or prompt_2 == null:
				console_add_line("Invalid teleport location!",true)
			player.position = Vector2(prompt_1,prompt_2)
			console_add_line(str("Teleported player to X:",prompt_1,", Y:",prompt_2))
		elif command == "old_style":
			console_add_line("Enjoy the time machine ;)")
			player.set_player_texture("res://sprites/playerOLD.png","")
			player.old_style = true
		elif command == "change_weapon":
			if prompt_2 == "0":
				Globals.primary_slot_id = int(prompt_1)
				console_add_line("Changed primary slot. Use (update_weapons) to get them!")
			elif prompt_2 == "1":
				Globals.secondary_slot_id = int(prompt_1)
				console_add_line("Changed secondary slot. Use (update_weapons) to get them!")
			else:
				console_add_line("Invalid slot! 0 - Second slot, 1 - Third slot",true)
		elif command == "update_weapons":
			console_add_line("Updated weapons.")
			player.setup_weapons()
			setup_UI_pic()
		elif command == "kys":
			console_add_line("shut up bitch")
		elif command == "HOLIDAY2024":
			console_add_line("HOLIDAY 2024!!!!!!!")
		else:
			console_add_line(str("Invaild Command ",command,"! Try using (help) for all comands."),true)

func _on_debug_text_entered(new_text):
	console_line_entered(new_text)
	console_line_edit.clear()
#	("res://scenes/",new_text)
#
#	var newObj = preload(tit)
#
#	var obj = newObj.instance()
#	objectFolder.add_child(obj)
#	debug.clear()

func _on_Exit_button_up():
	if !player.old_style:
		$Transitionsandshit/going_out/Exit.play("going_out")
	elif player.old_style:
		get_tree().change_scene("res://scenes/UIs/MainMenu.tscn")

func _on_Exit_animation_finished(anim_name):
	Globals.go_back_to_main_menu()

func _on_Continue_button_up():
	$WhatTheFuckIsATag.interpolate_property(pause_menu,"modulate:a",pause_menu.modulate.a,0,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$WhatTheFuckIsATag.start()
	paused = false
	get_tree().paused = false

func _on_Options_button_up():
	optionsOn = true

func _on_Options_hidePause():
	optionsOn = false

func _on_menuCloses_toggled(button_pressed):
	Globals.menuCloses = button_pressed

func _on_Physics_toggled(button_pressed):
	Globals.phys = button_pressed

func _on_WhatTheFuckIsATag_tween_completed(object, key):
	pause_menu.hide()

#Temp
func _on_Primary_text_entered(new_text):
	Globals.primary_slot_id = int(new_text)
	$QMenu/Items/Weapons/Primary.text = ""

func _on_Secondary_text_entered(new_text):
	Globals.secondary_slot_id = int(new_text)
	$QMenu/Items/Weapons/Secondary.text = ""

func _on_UpdateGuns_button_up():
	player.setup_weapons()
	setup_UI_pic()

func _on_Clog_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/Maps/BossArenas/ClogsDome.tscn")

func _on_FileDialog_file_selected(path: String) -> void:
	player.set_player_texture(path)
	console_add_line(str("Changed player texture to ", path),false)



