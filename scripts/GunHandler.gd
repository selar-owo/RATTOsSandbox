extends Node2D

onready var timer := $Timer
onready var raycast := $RayCast2D
onready var sprite := $GunSprite
onready var shoot_noise := $GunShoot
onready var shell := $Shell
onready var recoil := $Recoil
onready var projectile_position: Node2D = $ProjectilePosition
onready var casing_position = $CasingPosition
onready var inspect_anim: AnimationPlayer = $Inspect

#item
export(int) var gun_id := 327

"""
ids for all guns

pistol - 0
assault rifle - 1
shotgun - 2
revolver - 3
bazooka - 4
the terraria - 5 (code in TheTerraria.gd)

327 is if it doesnt work

"""

#stats
export(float) var damage := 20.0
export(float) var cooldown_time := 0.5
export(float) var recoil_amount := 10.0
export(bool) var auto_shoot := true
export(bool) var projectile := false
var cooldown := false
export(int) var slot := 0 #slot 0 is first slot 1 is second
export(String) var UI_sprite := "res://sprites/`missingtexture.png"
export(String) var projectile_sprite := "res://sprites/`missingtexture.png"

func _ready():
	setup_gun()

func _process(delta):
	gun_handler()
#	inspect()

func inspect():
	if Input.is_action_just_pressed("inspect") and inspect_anim != null:
		if slot == 0 and Globals.slot2held or slot == 1 and Globals.slot3held:
			inspect_anim.play("Inspect")
	
	if Input.is_action_pressed("physbutton") or Input.is_action_pressed("pistolbutton") or Input.is_action_pressed("toolgunbutton"):
		if inspect_anim != null:
			inspect_anim.play("RESET")

func gun_id_to_weapon_type(type) -> int:
	match type:
		0: #hand held
			return 0
		1: #assault rifle
			return 1
		2: #shot gun
			return 2
		3: #revolver
			return 0
		4: #bazooka
			return 3
	return -1

func show_damage_number(collider,rayobj,defence):
	if collider.get_parent().health > 0:
		var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
		if defence >= damage:
			damagenumber.damage_number = 1
		else:
			damagenumber.damage_number = damage - collider.get_parent().defence
		damagenumber.position = rayobj.get_collision_point()
		collider.get_parent().get_parent().add_child(damagenumber)

func cast_ray(rayobj):
	shoot_noise.play()
	recoil.seek(0.0,true)
	recoil.play("ShootAnimation")
	rayobj.force_raycast_update()
	sprite.frame = 0
	sprite.play("default")
	cooldown = true
	timer.start()
	
	if casing_position != null and Globals.casing:
		var case := preload("res://scenes/particles/CasingParticle.tscn").instance()
		get_parent().get_parent().get_parent().add_child(case)
		case.global_position = casing_position.global_position
		case.emitting = true
		case.global_rotation = casing_position.global_rotation
		case.z_index = -1
	
	if !rayobj.is_colliding():
		if SaveSettings.load_cfg("Experimental","GenerateTrailWhenShootingAir"):
			create_line(projectile_position.global_position,projectile_position.global_position + Vector2(2000,0).rotated(global_rotation))
		return
	var collider = rayobj.get_collider()
	var attack := Attack.new()
	attack.weapon_type = gun_id_to_weapon_type(gun_id)
	attack.attack_point = rayobj.get_collision_point()
	attack.amount = damage
	create_line(projectile_position.global_position,attack.attack_point)
	
	if collider.get_name() == "HurtHitbox":
		show_damage_number(collider,rayobj,collider.get_parent().defence)
		if "detected_player" in collider.get_parent():
			collider.get_parent().detected_player = true
		if collider.get_parent().defence >= damage:
			attack.amount = collider.get_parent().defence + 1
		collider.get_parent().damage(attack)
	print(collider)

func create_line(a,b) -> void:
	var line := Line2D.new()
	get_parent().get_parent().get_parent().add_child(line)
	line.show_behind_parent = true
	line.width = 1
	line.material = preload("res://BulletCanvas.tres")
	line.gradient = preload("res://new_gradient.tres")
	line.add_point(a)
	line.add_point(b)
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(line,"width",0,0.2)
	yield(tween,"finished")
	line.queue_free()

func shoot_projectile(projectile) -> void:
	shoot_noise.play()
	recoil.play("NewRecoil")
	cooldown = true
	timer.start()
	var proj = ResourceLoader.load(projectile).instance()
	proj.global_position = projectile_position.global_position
	proj.damage = damage
	proj.rotation_degrees = global_rotation_degrees
	get_parent().get_parent().get_parent().add_child(proj)

func eject_shell():
	shell.emitting = true
	yield(get_tree().create_timer(0.1),"timeout")
	shell.emitting = false

func shoot():
	if !Globals.insideVehicle:
		if inspect_anim != null:
			inspect_anim.play("RESET")
#		rotation_degrees = lerp(rotation_degrees,rand_range(-recoil_amount,recoil_amount),0.1)
		match projectile:
			false:
				cast_ray(raycast)
				if gun_id == 2:
					cast_ray(raycast)
					cast_ray($RayCast2D2)
					cast_ray($RayCast2D3)
			true:
				shoot_projectile("res://scenes/projectiles/Rocket.tscn")

func recoil() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"rotation_degrees",rand_range(-recoil_amount,recoil_amount),0.5)
	tween.play()

func gun_handler():
	if slot == 0:
		self.visible = Globals.slot2held
	if slot == 1:
		self.visible = Globals.slot3held
	
	if Input.is_action_pressed("left_click") and !Globals.QmenuOpen and auto_shoot or Input.is_action_just_pressed("left_click") and !Globals.QmenuOpen and !auto_shoot:
		if !cooldown:
			if slot == 0 and Globals.slot2held:
				shoot()
			elif slot == 1 and Globals.slot3held:
				shoot()
	
	if Input.is_action_just_released("left_click"):
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(self,"rotation_degrees",0.0,0.5)
		tween.play()

func setup_gun():
#	match gun_id:
#		0: #pistol
#			print("pistol")
#			damage = 15
#			cooldown_time = 0.3
#			slot = 1
#			projectile = false
#			UI_sprite = "res://sprites/actualpistolspriteforreal.png"
#			projectile_sprite = "res://sprites/`missingtexture.png"
#		1: #assault rifle
#			print("ass rifle")
#			damage = 6
#			cooldown_time = 0.1
#			slot = 0
#			projectile = false
#			UI_sprite = "res://sprites/assaultrifleUI.png"
#			projectile_sprite = "res://sprites/`missingtexture.png"
#		2: #shotgun
#			print("shotgun")
#			damage = 50
#			cooldown_time = 2
#			slot = 0
#			projectile = false
#			UI_sprite = "res://sprites/shotgunUI.png"
#			projectile_sprite = "res://sprites/`missingtexture.png"
#		3: #revolver
#			print("revolver")
#			damage = 30
#			cooldown_time = 0.6
#			slot = 1
#			projectile = false
#			UI_sprite = "res://sprites/actualpistolspriteforreal.png"
#			projectile_sprite = "res://sprites/`missingtexture.png"
#		327: #uh oh!
#			print("err gun loading")
	
	match slot:
		0:
			Globals.slot2pic = UI_sprite
		1:
			Globals.slot3pic = UI_sprite
	
	timer.wait_time = cooldown_time

func _on_Timer_timeout():
	cooldown = false
