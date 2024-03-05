extends KinematicBody2D

export(bool) var teleport_allowed := true
export(bool) var qmenu_allowed := true
export(bool) var noclip_allowed := true
export(bool) var movement_allowed := true
export(bool) var weapons_allowed := true

export(bool) var passive_teleport_allowed := true
export(bool) var passive_qmenu_allowed := true
export(bool) var passive_noclip_allowed := true
export(bool) var passive_movement_allowed := true

var sprintspeed:bool = true
var walking := false
export(int) var health = 100
export(int) var defence = 0
export(int,0,200) var intertia = 100
const speed:int = 140 #120
const acceleration := 5
const sprint_speed:int = 80
var pistol_damage:int = 10
var slot_id := 0
onready var anim:Node = get_node("Sprint")
onready var sprite:Node = get_node("Sprite")
onready var cam:Node = get_node("Camera2D")
onready var heldgun:Node = get_node("heldgun")
onready var phys_glow:Node = get_node("physglow")
onready var collision:Node = get_node("CollisionShape2D")
onready var intarea:Node = get_node("intArea/CollisionShape2D")
onready var held_sprite:Node = $heldgun/heldgun
onready var held_sprite_unanim:Node = $heldgun/heldgun/physgun
onready var pistol_sprite:Node = $heldgun/heldgun3
onready var stepSound:Node = $Walk
onready var gun_ray:Node = $heldgun/heldgun3/RayCast2D
onready var UI:Node = $"../UI" #This UI is the outdated version, use HUD instead! ok faggot guess i FUCKING WILL :3
onready var interact: AnimationPlayer = $Hand/Interact
onready var root_node: Node2D = $".."
onready var vehicle_timer: Timer = $VehicleTimer
onready var hand_sprite = $Hand/Sprite
onready var physgun_animations = $heldgun/physgunAnimations
onready var physgun_animation_player = $heldgun/physgunAnimations/AnimationPlayer
onready var slots_node = $Slots
var velocity = Vector2()
var vehicle_cooldown := false

var old_style := false

signal damaged

onready var weapons_folder := $Weapons

onready var open = $heldgun/physgunAnimations/Open
onready var close = $heldgun/physgunAnimations/Close
onready var loop = $heldgun/physgunAnimations/Loop
var defopen
var defclose
var defloop

export(Array) var inventory := []
export(Dictionary) var slots := {
	0: {"id": 0,"isheld":true},
	1: {"id": -1,"isheld":false},
	2: {"id": -1,"isheld":false},
}
var held_id := -1

func setPlayerTexture():
	if Globals.playerSprite != null:
		sprite.set_texture(Globals.playerSprite)

func _physics_process(delta: float) -> void:
	if old_style == false:
		new_movement(delta)
	elif old_style == true:
		movement(delta)

func unequip_items() -> void:
	for i in slots.values():
		i["isheld"] = false

func _process(delta):
	health_changed_checker()
	get_input()
	vehint()
	camera_shiz(delta)
	if SaveSettings.load_cfg("PhysicsStuff","MaxHealth") != 99999:
		health = clamp(health,-50,SaveSettings.load_cfg("PhysicsStuff","MaxHealth"))
#	pew_handler()

func change_camera_zoom(zoom:Vector2,ease_type,duration:float) -> void:
	var tween = get_tree().create_tween().set_ease(ease_type).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(cam,"zoom",zoom,duration)
	tween.play()

func camera_shiz(delta) -> void:
	cam.offset = lerp(cam.position,cam.position - (get_global_mouse_position() - position) * -1,0.05)

func _ready():
	Globals.insideVehicle = false
	cam.zoom = Vector2(SaveSettings.load_cfg("VisualsAudio","Zoom"),SaveSettings.load_cfg("VisualsAudio","Zoom"))
	var idx := 0
	for i in slots_node.get_children():
		if i.get_child_count() == 0:
			slots[idx]["id"] = -1
			idx += 1
			continue
		slots[idx]["id"] = i.get_child(0).handler.id
		idx += 1

func set_player_texture(path,hand_path = null):
	sprite.set_texture(ResourceLoader.load(path))
	if hand_path != null:
		hand_sprite.set_texture(ResourceLoader.load(hand_path))

func new_movement(delta):
	if movement_allowed and passive_movement_allowed:
		look_at(get_global_mouse_position())
		var input = Vector2.ZERO
		var cur_speed = speed
		if Input.is_action_pressed("sprint"):
			cur_speed += sprint_speed
		input.x = Input.get_action_raw_strength("move_right") - Input.get_action_strength("move_left")
		input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		velocity = lerp(velocity,input * cur_speed,acceleration * delta)
		move_and_slide(velocity,Vector2.UP,false,4,0.785398,!SaveSettings.load_cfg("Experimental","InteractPhysics"))
		
		if SaveSettings.load_cfg("Experimental","InteractPhysics"):
			for index in get_slide_count():
				var collision = get_slide_collision(index)
				if collision.collider.is_class("RigidBody2D"):
					collision.collider.apply_impulse(position - collision.collider.position,-collision.normal * intertia)

func movement(delta):
	if movement_allowed or passive_movement_allowed:
		look_at(get_global_mouse_position())
		velocity = move_and_slide(velocity)
		velocity.x = 0
		velocity.y = 0
		
		#all others
		if Globals.insideVehicle == false:
			if Input.is_action_pressed("move_down") and sprintspeed == true:
				velocity.y += speed / 1.4
				walking = true
				anim.play("onSprint")
				anim.seek(0.0,true)
			if Input.is_action_pressed("move_left") and sprintspeed == true:
				velocity.x -= speed / 1.4
				walking = true
				anim.play("onSprint")
				anim.seek(0.0,true)
			if Input.is_action_pressed("move_up") and sprintspeed == true:
				velocity.y -= speed / 1.4
				walking = true
				anim.play("onSprint")
				anim.seek(0.0,true)
			if Input.is_action_pressed("move_right") and sprintspeed == true:
				velocity.x += speed / 1.4
				walking = true
				anim.play("onSprint")
				anim.seek(0.0,true)
			
			if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_down"):
				walking = false
			
			if walking == true and !stepSound.playing:
				stepSound.play()
			elif walking == false:
				stepSound.stop()
			
			if Input.is_action_pressed("move_down"):
				velocity.y += speed
				walking = true
			if Input.is_action_pressed("move_left"):
				velocity.x -= speed
				walking = true
			if Input.is_action_pressed("move_up"):
				velocity.y -= speed
				walking = true
			if Input.is_action_pressed("move_right"):
				velocity.x += speed
				walking = true
		
		if Globals.insideVehicle == true:
			stepSound.stop()
		velocity.normalized()
	else:
		stepSound.stop()

#func pew_handler():
#	if Input.is_action_just_pressed("left_click") and Globals.slot2held and !UI.QmenuOpen:
#		$heldgun/heldgun3/GunShoot.play()
#		gun_ray.force_raycast_update()
#		pistol_sprite.frame = 0
#		pistol_sprite.play("default")
#		if !gun_ray.is_colliding():
#			return
#		var collider = gun_ray.get_collider()
#		if collider.get_name() == "HurtHitbox":
#			collider.get_parent().damage(pistol_damage)

func delete_all_weapons():
	for n in weapons_folder.get_children():
#		Globals.slot1held = false
#		Globals.slot2held = false
		n.queue_free()

func camera_shake(amount,times):
	for _i in range(times):
		var x = rand_range(-amount,amount)
		var y = rand_range(-amount,amount)
		randomize()
		cam.position = sprite.position + Vector2(x,y)
		yield(get_tree().create_timer(0.05),"timeout")
	cam.position = sprite.position

func instance_weapon(type):
	var weapon = ResourceLoader.load(type).instance()
	weapons_folder.add_child(weapon)

#GO HERE FOR le waepon....
func setup_weapons():
	delete_all_weapons()
	if Globals.secondary_slot_id == 0:
		instance_weapon("res://scenes/weapons/Pistol.tscn")
	if Globals.primary_slot_id == 1:
		instance_weapon("res://scenes/weapons/AssaultRifle.tscn")
	if Globals.primary_slot_id == 2:
		instance_weapon("res://scenes/weapons/Shotgun.tscn")
	if Globals.secondary_slot_id == 3:
		instance_weapon("res://scenes/weapons/Revolver.tscn")
	if Globals.primary_slot_id == 4:
		instance_weapon("res://scenes/weapons/Bazooka.tscn")
	if Globals.primary_slot_id == 5:
		instance_weapon("res://scenes/weapons/TheTerraria.tscn")

func change_slot(slot) -> void:
	var old_state = slots[slot]["isheld"]
	unequip_items()
	slots[slot]["isheld"] = !old_state
	slots_node.get_child(slot).visible = slots[slot]["isheld"]
	if slots[slot]["isheld"]: held_id = slots[slot]["id"]
	else: held_id = -1
	print(slots[slot]["isheld"])

func get_input():
	if Input.is_action_just_pressed("tp") and teleport_allowed or Input.is_action_just_pressed("tp") and passive_teleport_allowed:
		position = get_global_mouse_position()
	
	if weapons_allowed:
		if Input.is_action_just_pressed("physbutton"):
			change_slot(0)
		
		if Input.is_action_just_pressed("toolgunbutton"):
			change_slot(1)
		
		if Input.is_action_just_pressed("pistolbutton"):
			change_slot(2)
	
	if Input.is_action_just_pressed("noclip") and noclip_allowed or Input.is_action_just_pressed("noclip") and passive_noclip_allowed:
		Globals.noclip = !Globals.noclip
		collision.disabled = Globals.noclip
		if Globals.noclip == true:
			sprite.modulate.a8 = 100
		else:
			sprite.modulate.a8 = 255
	
	
	if Input.is_action_just_pressed("interact"):
		interact.seek(0.0,true)
		interact.play("Interact")
		if Globals.insideVehicle:
			vehicle_cooldown = true
		else:
			vehicle_cooldown = true
	
	if Input.is_action_just_pressed("map"):
		Globals.mapOn = !Globals.mapOn
		cam.current = !Globals.mapOn
	
	if Input.is_action_pressed("sprint"):
		sprintspeed = true
	else:
		sprintspeed = false
	Vector2().normalized()

func _delete_line(line) -> void:
	line.queue_free()

func hide_weapons():
	held_sprite.hide()
	held_sprite_unanim.hide()
	pistol_sprite.hide()

var temp_health := 0
func health_changed_checker():
	if temp_health != health and !UI.has_method("summonBlock"):
		UI.health_bars.player_damaged()
		temp_health = health

func damage(attack:Attack):
	health -= attack.amount
	camera_shake(attack.amount,3)
	emit_signal("damaged")
	if attack.amount >= 5:
		$HurtNoise.play()
		$Hurt.seek(0,true)
		$Hurt.play("Hurt")
	if self.get_parent().get_name() == "MeatLands" and health <= 0:
		get_tree().change_scene("res://scenes/Maps/Flatlands.tscn")
	elif health <= 0:
		get_tree().reload_current_scene()


func vehint():
	intarea.disabled = Globals.insideVehicle
	if Globals.noclip == false:
		collision.disabled = Globals.insideVehicle

func _on_intArea_area_entered(area):
	pass

func _on_HandArea_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("parried") and area.get_name() == "HurtHitbox":
		area.get_parent().parried()
		interact.play("Parried")

func _on_Timer_timeout() -> void:
	vehicle_cooldown = false
