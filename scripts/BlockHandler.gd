extends RigidBody2D

onready var rigid:Node = get_node(".")
onready var sprite:Node = get_node("Sprite")
onready var collisionbox:Node = get_node_or_null("CollisionShape2D")
onready var anim:Node = get_node_or_null("AnimationPlayer")
onready var animsprite:Node = get_node_or_null("AnimatedSprite")
onready var catsalad:Node = get_node_or_null("CatSalad")
onready var nav:Node = get_node_or_null("NavigationAgent2D")

export(int) var health
export(int) var defence
export(int) var damage := 0
var maximum_health
var damage_percent

#BITCH!!!
onready var tween_boy = $"../../Tween"
onready var ui_spr = $"../../UI/TextureRect"
onready var darkness = $"../../asItGrows"
var can_place := false


#misc tags
export(bool) var spin = false
export(bool) var move_rotation:bool = false
export(bool) var useable:bool = false
export(bool) var dont_spawn:bool = false
export(bool) var redstone:bool = false
export(bool) var bleedable:bool =false
export(bool) var destroyable:bool = false
export(bool) var keycard := false
export(bool) var random_rotation := false
export(int) var keycard_id := 0
export(bool) var health_blood:bool = false
export var ice_cream_machine:bool = false
export var ice_cream_texture:bool = false
export var so_cool_button := false
export var sex_button := false

#AI tags
export(bool) var angry_AI:bool = false
export(bool) var rat_AI:bool = false
export(bool) var amog_AI:bool = false
export(bool) var grimblo_AI:bool = false
export(bool) var clog_AI:bool = false
export(bool) var elcreatura_AI:bool = false
export(bool) var hurtable:bool = false
export(bool) var sentry_AI:bool = false

export(Array) var rat_speed := [
	50,
	100
]
export(float) var rat_rotation_speed := 25

#specific tags
export(bool) var vehicle:bool = false
export(bool) var bobm:bool = false

var laborginie:bool = false
var is_dead := false
var car_particles := [$CarParticle, $CarParticle2, $CarParticle3, $CarParticle4]

#vehicle shit
onready var vehicleArea:Node = get_node_or_null("vehicleArea")
onready var vehicleCam:Node = get_node_or_null("VehicleCamera")
onready var player:Node = get_node_or_null("../../Player")
var vehicleIsActive:bool = false
onready var enerporal:Node = get_node_or_null("enerfuckingporal")

#bullshit
export(bool) var carObject:bool = false
export(bool) var pistonTrue:bool = false
export(bool) var iceCreamTrue:bool = false
export(bool) var pussyGameTrue:bool = false
export(bool) var wisetree:bool = false
export(bool) var boombox:bool = false
export(bool) var football:bool = false
export(bool) var hatch:bool = false
onready var save_file = SaveFile.game_data
onready var goobs:Node = $Goobs
onready var amogos := $amogos
onready var piston_head := $PistonHead
onready var blood := $Blood
onready var blood_particle := $AlsoBlood
onready var fragments := $Fragments
onready var break_anim := $Broken
onready var break_overlay := $Overlay
onready var ingame_objects: Node2D = $".."
onready var machine_menu: Control = $MachineMenu
onready var song: AudioStreamPlayer2D = $Song
onready var root_node: Node2D = $"../.."
onready var ui: CanvasLayer = $"../../UI"

var placing: bool = true
var mouse: bool = false
var gunning: bool = false
var intArea: bool = false
var piston_activated:bool = false
var isOurple:bool = false
export var isSpawning:bool = false
var ratAttracted:bool = false
var ratAttPos = Vector2(1,1)
var missing := load("res://sprites/`missingtexture.png")
var redstoneON:bool = false
var destroyed := false
var creature_cooldown := false #the FUCKING nig
var creature_attacking := false #als taht

var goob := 0

#ice creme
export var flavors := []
export var cone_type := 0

#SOUNDS
onready var breaks: AudioStreamPlayer2D = $Breaks
export var block_hits := []
export var block_break:String

signal placedBlock

func _ready():
	startup_tags()
	spawn_noise()
	random_sprite()
	playerTag()
	teleport_meatboy()
	useable_tag_indicator()
	set_keycard_sprite()
	
	"""
	var tween_glow = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	sprite.self_modulate = Color(10,10,10)
	tween_glow.tween_property(sprite,"self_modulate",Color(1,1,1,1),1)
	kinda creates a banger effect..
	"""
	
	if !placing:
		sprite.scale = Vector2(0.6,0.6)
#		sprite.self_modulate = Color(2,2,2)
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
#		var tween_glow = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(sprite,"scale",Vector2(1,1),1)
#		tween_glow.tween_property(sprite,"self_modulate",Color(1,1,1,1),0.4)
		tween.play()
	
	if isOurple:
		animsprite.play()
		enerporal.play()
		player.camera_shake(5,5)
		$AnimatedSprite/OurpleSpawn.play("cool")
	
	collisionbox.disabled = true
	maximum_health = health
	print(rigid.get_name()," Generated")
	if break_anim != null:
		break_anim.connect("animation_finished",self,"_break_anim_finish")
	
	if ice_cream_texture:
		match cone_type:
			0:
				sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamConeDefault.png"))
			1:
				sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamConeSquare.png"))
		
		var pos = -5
		for i in flavors:
			var flavor_sprite := Sprite.new()
			sprite.add_child(flavor_sprite)
			match i:
				0: flavor_sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorChocolate.png"))
				1: flavor_sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorVanilla.png"))
				2: flavor_sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorStrawberry.png"))
				3: flavor_sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorMntChocolateChip.png"))
				4: flavor_sprite.set_texture(ResourceLoader.load("res://sprites/IceCreamFlavorCookiesNCreampng.png"))
			flavor_sprite.position.y = pos
			pos -= 3
	
	if dont_spawn:
		sprite.modulate.a = 1
		placing = false
		collisionbox.disabled = false
	
	if placing and song != null:
		song.stop()
	
	ui.console_add_line(str("Block ",self.get_name()," Generated."))
#	if rat_AI:
#		print(rigid.get_name()," Rat AI Tag Loaded")
#
#	if bobm:
#		print(rigid.get_name()," can explode any second now")
#
#	if spin:
#		print(rigid.get_name()," Spin Tag Loaded")
#
#	if angry_AI:
#		print(rigid.get_name()," Angry AI Tag Loaded")
#
#	if move_rotation:
#		print(rigid.get_name()," Move In Direction Tag Loaded")
#
#	if vehicle:
#		print(rigid.get_name()," Vehicle Tag Loaded")
#
#	if useable:
#		print(rigid.get_name()," Useable Tag Loaded, Type Depends on Item")

func spawn_noise() -> void:
	if !placing:
		var audio = AudioStreamPlayer2D.new()
		audio.set_stream(ResourceLoader.load("res://sounds/Spawn sound ULTRAKILL Sound Effect.mp3"))
		self.add_child(audio)
		audio.global_position = self.global_position
		audio.volume_db = -30
		audio.pitch_scale = 2
		audio.play()

func set_keycard_sprite():
	if keycard:
		sprite.set_texture(ResourceLoader.load(str("res://sprites/POCkeycard",keycard_id,".png")))

func useable_tag_indicator():
	if useable and Globals.show_indicator:
		var useable_interaction_indicator := preload("res://scenes/UseableIndicator.tscn").instance()
		print(self.get_name())
		useable_interaction_indicator.hitbox_size = $InteractionArea/CollisionShape2D.shape.extents
		self.add_child(useable_interaction_indicator)

func teleport_meatboy():
	if elcreatura_AI:
		self.global_position = player.position + Vector2(0,-50)

func damage(attack:Attack):
	if !placing:
		if hurtable:
			
			if bleedable and health > 0:
				blood.restart()
			if bleedable:
				blood_particle.seek(0,true)
				blood_particle.play("Hurt")
			if health_blood and health > 0:
				var blood = preload("res://scenes/otherstuffidk/Blood.tscn").instance()
				blood.global_position = attack.attack_point
				blood.heal_amount = attack.amount
				ingame_objects.add_child(blood)
			health -= (attack.amount - defence)
			
		if destroyable:
			health -= (attack.amount - defence)
			fragments.restart()
			damage_percent =int((float(health) / maximum_health) * 100)
			
			if damage_percent < 25:
				break_overlay.frame = 3
			if damage_percent >= 25 and damage_percent < 50:
				break_overlay.frame = 2
			if damage_percent >= 50 and damage_percent < 75:
				break_overlay.frame = 1
			if damage_percent >= 75 and damage_percent <= 100:
				break_overlay.frame = 0
			
			if health > 0:
				break_anim.play("vibrate")
				if breaks != null:
					var x = randi() % block_hits.size()
					breaks.set_stream(ResourceLoader.load(block_hits[x]))
					breaks.play()
			if health <= 0:
				$CollisionShape2D.queue_free()
				$Area2D.queue_free()
				$HurtHitbox.queue_free()
				break_overlay.hide()
				fragments.play_break()
				break_anim.play("Broken")
				if breaks != null:
					breaks.set_stream(ResourceLoader.load(block_break))
					breaks.play()
		print(health," ",self.get_name())

#func play_destroy_block_id(id,broken_audio):
#	if !broken_audio:
#		match id:
#			0:
#				var x = randi() % wood_hits.size()
#				breaks.set_stream(ResourceLoader.load(wood_hits[x]))
#				breaks.play()
#	else:
#		match id:
#			0:
#				breaks.set_stream(ResourceLoader.load(wood_break))
#				breaks.play()

#Brokey

func _break_anim_finish():
	queue_free()

#func _on_Broken_animation_finished(anim_name):
#	if anim_name == "Broken":
#		queue_free()

func _physics_process(delta):
	if player.old_style == false:
		new_placing_block()
	elif player.old_style == true:
		placingBlock()
	if !placing:
		physInteraction(delta)
		tag(delta)
		missing_texture()
		camera_sharting()

func missing_texture():
	if !sprite == null:
		if sprite.texture == null:
			sprite.set_texture(missing)
			ui.console_add_line(str(self.get_name()," is missing a texture!"),true)

func new_placing_block() -> void:
	if !dont_spawn:
		if placing == true:
			health = maximum_health
			sprite.modulate.a = 0.5
			Globals.slot1held = false
			Globals.slot2held = false
			Globals.slot3held = false
			Globals.physgunPicking = false
			rigid.position = get_global_mouse_position()
			if Input.is_action_just_released("left_click"):
				can_place = true
			if Input.is_action_just_pressed("left_click") and can_place:
				var node = self.duplicate()
				node.dont_spawn = true
				node.placing = false
				node.position = get_global_mouse_position()
				ingame_objects.add_child(node)
				if Globals.phys == true:
					node.mode = RigidBody2D.MODE_RIGID
			
			if Input.is_action_just_pressed("QMenu") or Input.is_action_just_pressed("physbutton") or Input.is_action_just_pressed("pistolbutton") or Input.is_action_just_pressed("toolgunbutton"):
				queue_free()
			
			if Input.is_action_just_pressed("phys_rotate"):
				rotation_degrees += 45


func placingBlock():
	if !dont_spawn:
		#placing
		if placing == true:
			Globals.slot1held = false
			Globals.slot2held = false
			Globals.slot3held = false
			Globals.physgunPicking = false
			rigid.position = get_global_mouse_position()
			if Input.is_action_just_released("left_click"):
				placing = false
				collisionbox.disabled = false
				if Globals.phys == true:
					rigid.mode = RigidBody2D.MODE_RIGID
	
	elif dont_spawn:
		placing = false
		collisionbox.disabled = false

func physInteraction(delta):
	if Input.is_action_pressed("left_click") and Globals.slot1held == true and mouse == true and Globals.physgunPicking == false:
		gunning = true
		Globals.physgunPicking = true
		if collisionbox != null:
			collisionbox.disabled = true
	if gunning == true:
		var direction2 = get_global_mouse_position() - position
		sprite.rotation_degrees = lerp(sprite.rotation_degrees,direction2.x * -1,0.4)
		if Input.is_action_just_pressed("phys_rotate"):
			rotation_degrees += 45
		
		if Input.is_action_just_released("left_click") or Input.is_action_just_pressed("physbutton") or Input.is_action_just_pressed("toolgunbutton") or Input.is_action_just_pressed("pistolbutton"):
			gunning = false
			sprite.rotation_degrees = 0
			collisionbox.disabled = false
			if rigid.mode != RigidBody2D.MODE_STATIC:
				var direction = get_global_mouse_position() - position
				linear_velocity = direction / delta
			Globals.physgunPicking = false
		position = get_global_mouse_position()

func playerTag():
	#player Tags
	for n in Globals.playerTags:
		n = true
		
		print(spin)
		
#		var tag = Node2D.new()
#		rigid.add_child(tag)
#		tag.set_name(n)
#		print("Added tag ",tag.get_name(), " To Object: ", tag.get_parent().get_name())

#THIS IS ALL JUST FOR THE FUCKING SENTRY
func show_damage_number(collider,rayobj,defence):
	if collider.get_parent().health > 0:
		var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
		if defence >= damage:
			damagenumber.damage_number = 1
		else:
			damagenumber.damage_number = damage - collider.get_parent().defence
		damagenumber.position = rayobj.get_collision_point()
		collider.get_parent().get_parent().add_child(damagenumber)

func shoot() -> void:
	var animation_player: AnimationPlayer = $Sentry/AnimationPlayer
	var gun_ray_cast: RayCast2D = $Sentry/RayCast2D
	var pew: AudioStreamPlayer2D = $Sentry/pew
	var attack = Attack.new()
	gun_ray_cast.force_raycast_update()
	pew.play()
	animation_player.seek(0.0,true)
	animation_player.play("shot")
	attack.amount = damage
	attack.attack_point = gun_ray_cast.get_collision_point()
	attack.weapon_type = 1
	if !gun_ray_cast.is_colliding():
		return
	var collider = gun_ray_cast.get_collider()
	if collider.get_name() == "HurtHitbox":
		show_damage_number(collider,gun_ray_cast,collider.get_parent().defence)
		collider.get_parent().damage(attack)
	print(collider)
	yield(get_tree().create_timer(1),"timeout")

func startup_tags():
	#rand rotation
	if random_rotation:
		randomize()
		self.rotation_degrees += rand_range(-360,360)

func tag(delta):
	if placing == false:
		
		#AIS
		
		#angry AI
		if angry_AI:
			pass
		
		#grimblo
		if grimblo_AI:
			pass
		
		#rat Ai
		if rat_AI:
			if health > 0:
				if ratAttracted == false:
					randomize()
					rotation_degrees += rand_range(-rat_rotation_speed,rat_rotation_speed) #-50.50
				else:
					look_at(ratAttPos.position)
				
				randomize()
				linear_velocity += Vector2(rand_range(rat_speed[0],rat_speed[1]), 0).rotated(rotation) #50,200
			else:
				$rat.stop()
		
		#sentry AI
		if sentry_AI:
			if health > 0:
				var sentry: Node2D = $Sentry
				if sentry.global_position.distance_to(player.global_position) <= 120:
					sentry.look_at(player.position)
					sentry.rotation_degrees += rand_range(-10,10)
					shoot()
		
		#clog AI
		if clog_AI:
			
			if health <= 2000 and health > 1000:
				defence = 2
				randomize()
				rotation_degrees += rand_range(-100,100)
				randomize()
				linear_velocity += Vector2(rand_range(75,100), 0).rotated(rotation)
			elif health <= 1000 and health > 0:
				defence = 0
				if !$Start.playing:
					$Start.play()
				randomize()
				rotation_degrees += rand_range(-150,150)
				randomize()
				linear_velocity += Vector2(rand_range(200,400), 0).rotated(rotation)
			elif !is_dead and health <= 0:
				$"../Flash".play("Flash")
				$"../ambione".stop()
				$Aura.stop()
				$Start.stop()
				is_dead = true
			
			if $"../UI/ProgressBar2" != null:
				$"../UI/ProgressBar2".value = health
				$"../UI/ProgressBar2/Label".text = str(health,"/2000")
			
		
		#el creatura AI
		if elcreatura_AI:
			
			if Input.is_action_just_pressed("creature_dash") and !creature_cooldown:
				$"rawr!!!".play()
				var direction = get_global_mouse_position() - position
				linear_velocity = direction * 8
				$Tween.interpolate_property(self,"modulate",Color(2,2,2),Color(1,1,1),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
				$Tween.start()
				creature_attacking = true
				creature_cooldown = true
				look_at(get_global_mouse_position())
				yield(get_tree().create_timer(0.2),"timeout")
				look_at(player.position)
				var player_direction = player.position - get_global_mouse_position()
				linear_velocity = player_direction * 5
				$Timer.start()
			
			if !creature_attacking:
				look_at(player.position)
				randomize()
				linear_velocity += Vector2(rand_range(5,10), 0).rotated(rotation)
		
		#amog AI
		if amog_AI:
			
			randomize()
			if round(rand_range(1,40)) == 1:
				randomize()
				amogos.pitch_scale = rand_range(-1,5)
				amogos.play()
			
			if ratAttracted == false:
				randomize()
				rotation_degrees += rand_range(-400,400)
				
			else:
				look_at(ratAttPos.position)
			
			randomize()
			linear_velocity += Vector2(rand_range(50,1000), 0).rotated(rotation)
		
		#EVERYTHING ELSE
		
		#boombox
		if boombox:
			if health <= 0 and !destroyed:
				$Song.stop()
				$ow.play()
				$Destroyed.restart()
				sprite.set_texture(ResourceLoader.load("res://sprites/boomboxDestroyedNew.png"))
				destroyed = true
				
		
		#i forgot like i genuienly dont remmbmer what this is it might be the so cool minions maybe
		if isSpawning:
			self.position = Vector2(self.position.x + rand_range(-1,1),self.position.y + rand_range(-1,1))
			player.camera_shake(1,1)
		
		#bobm
		if bobm:
			if mouse and Input.is_action_just_pressed("interact"):
				print("boom boom")
				anim.play("explode")
				$Explosion.play()
				player.camera_shake(1000,1000)
				yield(get_tree().create_timer(1),"timeout")
				get_tree().change_scene("res://scenes/EAS.tscn")
		
		#spin
		if spin:
			angular_velocity += 8
		
		#move towards direction
		if move_rotation:
			linear_velocity = Vector2(20, 0).rotated(rotation)
		
		#vehicle
		if vehicle:
			
			
			if placing == false: # WHY IS IT CHECKING IF ITS PLACING IT ALREADY FUCKING DOES IT FOR EVERYTHING
				if Input.is_action_just_pressed("interact"):
					if Globals.insideVehicle and vehicleIsActive:
						player.change_camera_zoom(Vector2(Globals.camera_zoom,Globals.camera_zoom),Tween.EASE_OUT,0) #0.5
						Globals.insideVehicle = false
						vehicleIsActive = false
						print("Exiting Vehicle ", rigid.get_name())
						player.position = rigid.position + Vector2(0, -50).rotated(rotation)
						player.vehicle_timer.start()
					
					if Globals.insideVehicle == false and vehicleIsActive == false and placing == false and intArea == true and mouse == true:
						player.change_camera_zoom(Vector2(0.8,0.8),Tween.EASE_IN_OUT,0) #1
						Globals.insideVehicle = true
						yield(get_tree().create_timer(0.1),"timeout")
						Globals.slot1held = false
						vehicleIsActive = true
						player.vehicle_timer.start()
						print("Entering Vehicle ", rigid.get_name())
			
			if Globals.insideVehicle and vehicleIsActive:
				Globals.slot1held = false
				Globals.slot2held = false
				Globals.slot3held = false
				var speed = 40 #40
				var rotspeed = 0.5 #0.5
				var vehicle_damp := 500 #500
				
				if laborginie == true:
					speed = 80
					rotspeed = 0.7
				
				if isOurple:
					speed = 120
					rotspeed = 0.8
				
				Globals.slot1held = false
				player.position = rigid.position
				if Input.is_action_pressed("move_down"):
					linear_velocity -= Vector2(speed, 0).rotated(rotation)
				if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
					angular_velocity -= rotspeed
				if Input.is_action_pressed("move_up"):
					linear_velocity += Vector2(speed, 0).rotated(rotation)
				if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"):
					angular_velocity += rotspeed
		
		#Useables
		if useable:
			
			#sex button
			if sex_button:
				$"../../UI/SoCool/SoCool".position = Vector2(rand_range(-20,20),rand_range(-20,20))
				
				if Input.is_action_just_pressed("interact") and mouse and intArea and !root_node.sex_mode:
					$"../../UI/SoCool/SoCool/SoCool".play("HeCums")
					$"../../Music".volume_db = -449141941294
					
			
			#so cool button
			if so_cool_button:
				if Input.is_action_just_pressed("interact") and intArea and mouse:
					anim.play("PlaySoCool")
			
			#key cart
			if keycard:
				if Input.is_action_just_pressed("interact") and intArea and mouse:
					match keycard_id:
						1:
							player.inventory.append("keycard1")
							ui.show_keycard(keycard_id)
							queue_free()
						2:
							player.inventory.append("keycard2")
							ui.show_keycard(keycard_id)
							queue_free()
						3:
							player.inventory.append("keycard3")
							ui.show_keycard(keycard_id)
							queue_free()
			
			#footballer
			if football:
				if Input.is_action_just_pressed("interact") and intArea:
					var distance = player.global_position - global_position
					linear_velocity = Vector2(12000 / global_position.distance_to(player.global_position),0).rotated(player.rotation)
			
			#piston
			if pistonTrue:
				
				if Input.is_action_just_pressed("interact") and mouse == true and intArea == true:
					piston_activated = !piston_activated
					if piston_activated == true:
						$Tween.interpolate_property(piston_head,"position:x",piston_head.position.x,-12,0.1,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
						$Tween.start()
					else:
						$Tween.interpolate_property(piston_head,"position:x",piston_head.position.x,0,0.1,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
						$Tween.start()
			
			#ice ream
			if iceCreamTrue:
				
				if Input.is_action_just_pressed("interact") and mouse == true and intArea == true:
					randomize()
					player.health += rand_range(10,20)
					Globals.physgunPicking = false
					queue_free()
			
			#MACHINE.....
			if ice_cream_machine:
				if Input.is_action_just_pressed("interact") and mouse and intArea:
					machine_menu.visible = !machine_menu.visible
			
			#wise tree
			if wisetree:
				var creatures := ["res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.12.30-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.12.35-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.13.43-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.13.44-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.14.16-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.19.39-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.20.41-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.27.49-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.06-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.11-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.32-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.29.13-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.33-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.36-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.54-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.56-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.57-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.59-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.13.46-removebg-preview.png"]
				var cum := randi() % creatures.size()
				if save_file.meat_beaten:
					queue_free()
				
				if cam_shake:
					$"../../UI/TextureRect".show()
					$"../../UI/TextureRect".set_texture(ResourceLoader.load(creatures[cum]))
					var x = rand_range(-100,100)
					var y = rand_range(-100,100)
					$"../../UI/TextureRect".rect_position = Vector2(0,0) + Vector2(x,y)
					randomize()
				else:
					$"../../UI/TextureRect".hide()
				$Light2D.energy = rand_range(0.5,1)
				$Light2D2.energy = rand_range(0,0.5)
				var x = sprite.position.x + rand_range(-4,4)
				var y = sprite.position.x + rand_range(-4,4)
				$Light2D2.position = Vector2(x,y)
				$Light2D.position = Vector2(x,y)
				$Light2D2.scale = Vector2(rand_range(0.102,0.202),rand_range(0.163,0.263))
				randomize()
				#old pitch 0.15 old volume 4.16
				
				if Input.is_action_just_pressed("interact") and mouse == true and intArea == true:
					$"../../UI/Clog".play("Clog")
					tween_boy.interpolate_property($"../../Player/Camera2D","zoom",$"../../Player/Camera2D".zoom,Vector2(0.1,0.1),1,Tween.TRANS_QUINT,Tween.EASE_IN)
					tween_boy.start()
			
			#pussy game
			if pussyGameTrue:
				goobs.text = str(goob)
				if Input.is_action_just_pressed("interact") and mouse == true and intArea == true:
					goob += 1
					catsalad.play()
					anim.seek(0.01,true)
					anim.play("Goob")
		
		if redstone:
			#piston
			if redstoneON == true:
				piston_activated = !piston_activated
				if piston_activated == true:
					anim.play("PistonOut")
				else:
					anim.play("PistonIn")

func random_sprite():
	
	#car
	if carObject:
		randomize()
		var car1 = preload("res://sprites/car1New.png")
		var car2 = preload("res://sprites/car2New.png")
		var car3 = preload("res://sprites/car3New.png")
		var car4 = preload("res://sprites/car4New.png")
		var car5 = preload("res://sprites/car5.png")
		
		var spriteDecider = round(rand_range(1,4))
		
		if spriteDecider == 1:
			sprite.set_texture(car1)
		if spriteDecider == 2:
			sprite.set_texture(car2)
		if spriteDecider == 3:
			sprite.set_texture(car3)
		if spriteDecider == 4:
			laborginie = true
			sprite.set_texture(car4)
		
		randomize()
		if round(rand_range(1,67.5210532556792132636281000000000007)) == 1 and !placing and !dont_spawn: #1 in 67.5210532556792132636281000000000007
			sprite.hide()
			animsprite.show()
			isOurple = true
		
		print("car",spriteDecider," texture")


func _on_Area2D_mouse_entered():
	mouse = true

func _on_Area2D_mouse_exited():
	mouse = false

func _on_Area2D_area_entered(area):
	pass
	#THIS CODE WORKIE DONT DELETE
#	if area.get_name() == "ThrottleArea" and area.get_parent().get_parent().pistonTrue:
#		self.linear_velocity += self.position - area.get_parent().get_parent().position * 1.2

func _on_InteractionArea_area_entered(area):
	if area.get_name() == "intArea":
		intArea = true

	if area.get_name() == "RatArea" and rat_AI:
		ratAttracted = true
		ratAttPos = area.get_parent()

func _on_InteractionArea_area_exited(area):
	if area.get_name() == "intArea":
		intArea = false

	if area.get_name() == "RatArea" and rat_AI:
		ratAttracted = false

func _on_RedstoneArea_area_entered(area):
	if redstone:
		redstoneON = true

func _on_RedstoneArea_area_exited(area):
	if redstone:
		redstoneON = false

#MEATBOSS THING
func _on_Flash_animation_finished(anim_name):
	Globals.does_have_goober = true
	get_tree().change_scene("res://scenes/Maps/Flatlands.tscn")

#W THING
func _on_Timer_timeout():
	creature_cooldown = false
	creature_attacking = false

func _on_DamageHitbox_area_entered(area):
	if area.get_name() == "HurtHitbox" and creature_attacking and area.get_parent().get_name() != "Player":
		var attack := Attack.new()
		attack.amount = 50
		attack.attack_point = self.position
		attack.weapon_type = 4
		area.get_parent().damage(attack)

func _on_MeatBossHitbox_area_entered(area):
	if area.get_name() == "HurtHitbox":
		area.get_parent().damage(10)

func _on_goalArea_area_entered(area):
	if area.get_name() == "footballArea" and !area.get_parent().placing:
		$goalSound.play()

var cam_shake := false

func camera_sharting():
	if cam_shake:
		player.camera_shake(10,1)

func _on_turnOffMusic_area_entered(area):
	if area.get_name() == "intArea":
		cam_shake = true
		tween_boy.interpolate_property($"../../UI/darkni","self_modulate:a",$"../../UI/darkni".self_modulate.a,0.3,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../asItGrows","color",$"../../asItGrows".color,Color(0.384314, 0, 0),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Player/Camera2D","zoom",$"../../Player/Camera2D".zoom,Vector2(0.3,0.3),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Music","pitch_scale",$"../../Music".pitch_scale,0.2,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Music","volume_db",$"../../Music".volume_db,-12,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.start()

func _on_turnOffMusic_area_exited(area):
	if area.get_name() == "intArea":
		cam_shake = false
		tween_boy.interpolate_property($"../../UI/darkni","self_modulate:a",$"../../UI/darkni".self_modulate.a,0,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../asItGrows","color",$"../../asItGrows".color,Color(1,1,1),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Player/Camera2D","zoom",$"../../Player/Camera2D".zoom,Vector2(Globals.camera_zoom,Globals.camera_zoom),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Music","pitch_scale",$"../../Music".pitch_scale,1,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.interpolate_property($"../../Music","volume_db",$"../../Music".volume_db,-24,2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween_boy.start()

func _on_Broken_animation_finished(anim_name: String) -> void:
	if anim_name == "Broken":
		queue_free()

func _on_Spawn_button_up() -> void:
	for i in ingame_objects.get_children():
		if i.has_method("physInteraction") and i.placing:
			i.queue_free()
	var icecream = ResourceLoader.load("res://scenes/useables/IceCreamCustomizeable.tscn").instance()
	icecream.flavors = machine_menu.flavors
	icecream.cone_type = machine_menu.cone_type
	ingame_objects.add_child(icecream)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "PlaySoCool":
		var socool = ResourceLoader.load("res://scenes/boss/SoCool.tscn").instance()
		self.get_parent().get_parent().add_child(socool)
		socool.position = self.position + Vector2(0,-200)
		$"../../Music".volume_db = -200
		queue_free()

func _on_InteractionArea_mouse_entered() -> void:
	mouse = true

func _on_InteractionArea_mouse_exited() -> void:
	mouse = false

func _on_SoCool_animation_finished(anim_name: String) -> void:
	if anim_name == "HeCums":
		root_node.sex_mode = true
