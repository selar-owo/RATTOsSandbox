extends KinematicBody2D

var doing_attack := false
export var phase := 1
export var health:float = 2000
export var defence:float = 3
onready var player := $"../Player"
onready var phase_timer: Timer = $PhaseTimer

var phase1_attacks := [
	0, #IDLE
	1, #SUMMON SO COOL MINIONS
	2, #SHOOT OUT BALLS OF LIGHT THAT EXPLODE ON CONTACT
	3, #ground slam (if player is near)
	4, #put little mini so cools around the player that explode
]

var phase2_attacks = [
	10, #idle but cooler
	11, #SUMMON SO COOL MINIONS BUT MORE
	12, #SHOOT OUT BIGGER BALLS OF LIGHT THAT EXPLODE INTO 3 SMALLER BALLS OF LIGHT ON CONTACT
	13, #PUT FIRE AROUND SO COOL
	14, #DASH TOWARDS PLAYER BUT INCREASES DEFENCE BY A BUNCH
	15, #DASH TOWARDS PLAYER BUT EACH DASH CREATES BALLS OF LIGHT
	16, #SHOOT LIGHTNING BOLT AT PLAYER
]

var cur_attack:int

func _process(delta: float) -> void:
	phase_decider()
	attacks()

func damage(attack:Attack):
	if attack.weapon_type != 6:
		health -= (attack.amount - defence)
		var blood = load("res://scenes/otherstuffidk/Blood.tscn").instance()
		blood.global_position = attack.attack_point
		blood.heal_amount = attack.amount
		blood.blood_size = Vector2(1,1)
		get_parent().add_child(blood)

func phase_decider() -> void:
	if health <= 1000:
		phase = 2
	elif health > 1000:
		phase = 1
	
	match phase:
		1:
			phase_timer.wait_time = 4
		2:
			phase_timer.wait_time = 2

func attacks() -> void:
	match cur_attack:
		#phase 1
		#stationary, still a lot of attacks but only 1 attack at a time
		0:
			doing_attack = false
		1:
			print("MINION")
		2:
			spawn_light_balls(20,0,self.position)
		3:
			print("GROUND SLAM")
		4:
			print("minions around player explode")
		
		#phase 2
		#starts moving with the dash attack, can do any amount of attack at the same time
		10:
			doing_attack = false
		11:
			print("MINION 2")
		12:
			spawn_light_balls(60,0,player.position + Vector2(rand_range(-250,250),rand_range(-250,250)))
		13:
			print("FIRE AROUND")
		14:
			print("DASH TOWARD + DEFENCE INCREASE")
		15:
			print("LIGHTNING BOLT")

func _on_PhaseTimer_timeout() -> void:
	match phase:
		1:
			if !doing_attack:
				var x = randi() % phase1_attacks.size()
				cur_attack = x
		2:
			doing_attack = false
			var x = randi() % phase2_attacks.size()
			cur_attack = x + 10

#attack functions
func spawn_light_balls(amount,idle,pos:Vector2) -> void:
	if !doing_attack:
		if phase != 2:
			doing_attack = true
		for i in range(amount):
			var ball = ResourceLoader.load("res://scenes/boss/attacks/BallOfLight.tscn").instance()
			get_parent().add_child(ball)
			ball.position = pos
			ball.look_at(player.position)
			yield(get_tree().create_timer(0.1),"timeout")
		cur_attack = idle
