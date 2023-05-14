extends KinematicBody2D

export(int) var health := 4000
export(int) var defence := 0
export(bool) var in_boss_room := false

onready var boss_cooldown := $BossCooldown

var attacks := [
	#phase1
	0, #idle
	1, #projectile throw attack
	2, #spike explody thing that follows player
	
	#phase2
	10, #idle
]

var curattack:int

func _process(delta):
	healthbar()
	phase_2()
	attack_state()
	boss_room_state()

func boss_room_state():
	$"../BossBar".visible = in_boss_room

func attack_state():
	match curattack:
		0:
			pass
		1:
			print("1")
			curattack = 0
		2:
			print("2")
			curattack = 0
		3:
			print("3")
			curattack = 0

func phase_2():
	if health > 2000:
		defence = 0
	elif health > 0 and health <= 2000:
		defence = 3
	elif health <= 0:
		print("Youch!")

func healthbar():
	$"../BossBar/Bar/BarLabel".text = str(health,"/4000")
	$"../BossBar/Bar".value = health

func damage(amount):
	health -= (amount - defence)
	$Hurt.seek(0.0,true)
	$Hurt.play("Hurt")

func select_rand_phase():
	var x := randi() % attacks.size()
	curattack = attacks[x]

#cooldown
func _on_BossCooldown_timeout():
	print("starting")
	boss_cooldown.start()

