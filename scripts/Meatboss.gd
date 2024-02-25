extends KinematicBody2D

export(int) var health := 4000
export(int) var defence := 0
export(int) var max_speed := 100
export(bool) var cutscene_finished := true
var cooldown:bool
onready var phase_1_delay = $Phase1Delay
onready var phase_2_delay = $Phase2Delay
var phase2_trans := false
onready var player := $"../../Player"
onready var animated_sprite = $AnimatedSprite
onready var blood_dark = $"../../BloodDark"
onready var aura: AudioStreamPlayer2D = $Aura
onready var agent := $NavigationAgent2D
onready var timer := $Timer
onready var tween := $Tween
onready var dash_alert: AudioStreamPlayer2D = $DashAlert
onready var dash_noise: AudioStreamPlayer2D = $DashNoise
onready var spawn_minions: AudioStreamPlayer2D = $SpawnMinions
onready var boss_bar: TextureProgress = $"../../BossBar/BossBar"

var velocity := Vector2()
var pos = Vector2()
var rot   

func roat():
	pos = global_position
	
	rot = rad2deg((pos).angle())
	
	print(rot)
	
	if(rot >= -90 and rot <= 90):
		animated_sprite.flip_v = false
	else:
		animated_sprite.flip_v = true

var phase1_attacks := [
	0, #IDLE
	1, #SUMMON MINIONS
	2, #SWEEP
]

var phase2_attacks = [
	10, #idle but cooler
	11, #FASTER_SWEEP
	12, #MANY MINION MOVIE
	13 #EYE_BLASTER
]

var cur_attack

func _physics_process(delta):
	boss_modes(delta)
	boss_bar()
	phase2_transition()

func _process(delta):
	roat()
	play_idle()
	boss_bar.health = health

func phase2_transition():
	if !phase2_trans and health <= 2000:
		player.camera_shake(10,10)
		animated_sprite.animation = "phase2"
		tween.interpolate_property(blood_dark,"color",Color(1,1,1),Color(1, 0.603922, 0.603922),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		tween.start()
		$"../../BossMusic".stream = load("res://sounds/ost/clogphase2.mp3")
		$"../../BossMusic".play()
		phase_1_delay.stop()
		phase_2_delay.start()
		cur_attack = 10
		max_speed = 150
		phase2_trans = true

func _ready():
	ready_naviagtion()
	boss_bar._name = "Clog the Devourer"
	boss_bar.max_health = health

func damage(attack:Attack):
	if attack.weapon_type != 6:
		if attack.weapon_type == 3:
			health -= ((attack.amount * 4) - defence)
		else:
			health -= (attack.amount - defence)
		var blood = load("res://scenes/otherstuffidk/Blood.tscn").instance()
		blood.global_position = attack.attack_point
		blood.heal_amount = attack.amount
		blood.blood_size = Vector2(2,2)
		get_parent().get_parent().add_child(blood)

func dash():
	#wait
	tween.interpolate_property($AnimatedSprite,"modulate",Color(2, 2, 2),Color(1, 1, 1),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = true
	dash_alert.play()
	yield(get_tree().create_timer(1),"timeout")
	#dash
	tween.interpolate_property(self,"position",self.position,player.position + Vector2(-75,-75),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = false
	animated_sprite.frame = 0
	dash_noise.play()
	yield(get_tree().create_timer(1),"timeout")
	#wait
	tween.interpolate_property($AnimatedSprite,"modulate",Color(2, 2, 2),Color(1, 1, 1),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = true
	dash_alert.play()
	yield(get_tree().create_timer(1),"timeout")
	#dash
	tween.interpolate_property(self,"position",self.position,player.position + Vector2(75,75),2,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = false
	animated_sprite.frame = 0
	dash_noise.play()
	yield(get_tree().create_timer(3),"timeout")
	animated_sprite.playing = true


func player_directy_position_thing():
	var player_direction = player.global_position - self.global_position
	return player_direction

func faster_dash():
	#wait
	tween.interpolate_property($AnimatedSprite,"modulate",Color(2,2,2),Color(1, 1, 1),0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = true
	animated_sprite.frame = 0
	dash_alert.play()
	yield(get_tree().create_timer(0.5),"timeout")
	#dash
	tween.interpolate_property(self,"position",self.position,player.position + Vector2(-50,-50),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = false
	dash_noise.play()
	yield(get_tree().create_timer(0.5),"timeout")
	#wait
	tween.interpolate_property($AnimatedSprite,"modulate",Color(2, 2, 2),Color(1, 1, 1),0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = true
	dash_alert.play()
	animated_sprite.frame = 0
	yield(get_tree().create_timer(0.5),"timeout")
	#dash
	tween.interpolate_property(self,"position",self.position,player.position + Vector2(50,50),1,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	animated_sprite.playing = false
	dash_noise.play()
	yield(get_tree().create_timer(1),"timeout")
	animated_sprite.playing = true

func boss_bar():
	$"../../BossBar/Bar".value = health
	$"../../BossBar/Bar/BarLabel".text = str(health,"/4000")

func summon_minion(amount):
	tween.interpolate_property(animated_sprite,"self_modulate",Color(1, 0, 0),Color(1,1,1),4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	spawn_minions.play()
	for i in range(amount):
		var minion := preload("res://scenes/boss/minions/Minion.tscn").instance()
		$"..".add_child(minion)
		yield(get_tree().create_timer(0.1),"timeout")

func summon_eyes(amount):
	tween.interpolate_property(animated_sprite,"self_modulate",Color(1, 0, 0),Color(1,1,1),4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()
	for i in range(amount):
		var minion := preload("res://scenes/boss/attacks/EyeballLauncher.tscn").instance()
		$"..".add_child(minion)
		yield(get_tree().create_timer(0.1),"timeout")

func play_idle():
	if cutscene_finished:
		aura.play()
		return

func boss_modes(delta):
	if cutscene_finished:
		#find current mode and do action
		match cur_attack:
			0:
				if !cooldown:
					phase_1_delay.start()
					cooldown = true
				navigation(delta)
			1:
				summon_minion(3)
				print("summon minions phase 1")
				cur_attack = 0
			2:
				dash()
				print("dash phase 1")
				cur_attack = 0
			
			10:
				if !cooldown:
					phase_2_delay.start()
					cooldown = true
				navigation(delta)
			11:
				faster_dash()
				print("dash phase 2")
				cur_attack = 10
			12:
				summon_minion(4)
				print("summon minions phase 2")
				cur_attack = 10
			13:
				summon_eyes(rand_range(5,20))
				randomize()
				print("summon eyes phase 2")
				cur_attack = 10

func _on_Phase1Delay_timeout():
	#when the timer ends do next action
	var x := randi() % phase1_attacks.size()
	cur_attack = phase1_attacks[x]
	cooldown = false

func _on_Phase2Delay_timeout():
	#when the timer ends do next action
	var x = randi() % phase2_attacks.size()
	cur_attack = phase2_attacks[x]
	cooldown = false

#nartigation
func ready_naviagtion():
	agent.set_target_location(player.global_position)
	timer.connect("timeout",self,"update_pathfinding")

func navigation(delta):
	if health > 0:
		if agent.is_navigation_finished():
			return
		
		var direction := global_position.direction_to(agent.get_next_location())
		
		var desired_velocity := direction * max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		
		velocity = move_and_slide(velocity)
		self.rotation = velocity.angle()

func update_pathfinding():
	agent.set_target_location(player.global_position)

func _on_MeatBossHitbox_area_entered(area):
	if area.get_name() == "HurtHitbox" and !"minin" in area.get_parent():
		var attack = Attack.new()
		attack.amount = 20
		attack.attack_point = area.get_parent().position
		attack.weapon_type = 6
		area.get_parent().damage(attack)

func _on_ClogEnter_animation_started(anim_name):
	player.movement_allowed = false
	Globals.mapOn = false
	$"../../CutsceneCamera".current = true
	tween.interpolate_property($"../../CutsceneCamera","global_position",player.global_position,Vector2(-390,-854),3,Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween.start()

func _on_CutsceneArea_area_entered(area):
	if area.get_name() == "intArea":
		$"../../ClogEnter".play("Enter")

func _on_Fuck_tween_completed(object, key):
	player.movement_allowed = true
	cutscene_finished = true
	$"../../Player/Camera2D".current = true
	$"../../CutsceneArea".queue_free()

func _on_ClogEnter_animation_finished(anim_name):
	$"../../Fuck".interpolate_property($"../../CutsceneCamera","global_position",$"../../CutsceneCamera".global_position,player.global_position,1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$"../../Fuck".start()
