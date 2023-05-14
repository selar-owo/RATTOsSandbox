extends KinematicBody2D

export(int) var health := 35
export(int) var defence := -5
export(bool) var minin := true
export var so_cool_boss_minion := false
export var damage_amount := 10
export var max_speed := 250
var parried := false
var velocity := Vector2()

var minion_sprite := [
	"res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.12.30-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.12.35-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.13.43-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.13.44-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.14.16-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.19.39-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-02_18.20.41-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.27.49-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.06-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.11-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.28.32-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/Copy_of_DALL_E_2023-03-03_03.29.13-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.33-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.36-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.54-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.56-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.57-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.12.59-removebg-preview.png", "res://sprites/gog creatura-20230303T155947Z-001/gog creatura/DALL_E_2023-03-02_18.13.46-removebg-preview.png"
]
onready var sprite = $Sprite
onready var agent = $NavigationAgent2D
onready var timer = $Timer
onready var player = $"../../Player"
onready var ui = $"../../UI"
onready var so_cool = $"../../SoCool"
onready var foliage: TileMap = $"../Foliage"
onready var shoot: AnimationPlayer = $shoot
onready var root_node: Node2D = $"../.."
onready var spawn: AudioStreamPlayer2D = $Spawn

func _ready():
	ready_naviagtion()
	if so_cool_boss_minion:
		position = so_cool.position + Vector2(rand_range(20,-20),rand_range(20,-20))
	max_speed += rand_range(-50,50)
	spawn.pitch_scale = rand_range(0.95,1.05)
	randomize()
#	global_position = $"../so_cool".global_position + Vector2(0,50)

func move() -> void:
	velocity += Vector2(max_speed,0).rotated(rotation)
	move_and_collide(velocity)

func _physics_process(delta):
	root_node.in_combat = true
	
	if !parried:
		navigation(delta)
	elif parried:
		move()

func damage(attack:Attack):
	if attack.weapon_type != 6:
		if health > 0:
			var blood = load("res://scenes/otherstuffidk/Blood.tscn").instance()
			blood.global_position = attack.attack_point
			blood.heal_amount = attack.amount
			blood.blood_size = Vector2(1,1)
			get_parent().get_parent().add_child(blood)
		health -= (attack.amount - defence)
		if health <= 0:
			$death.play("die")

func random_sprite():
	var x := randi() % minion_sprite.size()
	sprite.set_texture(ResourceLoader.load(minion_sprite[x]))

#nav
func ready_naviagtion():
	agent.set_target_location(player.global_position)
	timer.connect("timeout",self,"update_pathfinding")

func navigation(delta):
	if health > 0:
		if agent.is_navigation_finished():
			return
		
		var direction := global_position.direction_to(agent.get_next_location())
		
		var desired_velocity = direction * max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		
		velocity = move_and_slide(velocity)
#		if !parried:
#			self.rotation = velocity.angle()

func update_pathfinding():
	if !parried:
		agent.set_target_location(player.global_position)

func _on_DamageHitbox_area_entered(area):
	if area.get_name() == "HurtHitbox":
		if area.get_parent().get_name() != "so_cool" and !parried:
			var attack = Attack.new()
			attack.amount = damage_amount
			attack.attack_point = area.get_parent().position
			attack.weapon_type = 6
			area.get_parent().damage(attack)
		elif parried:
			var explosion = ResourceLoader.load("res://scenes/otherstuffidk/Explosion.tscn").instance()
			explosion.explosion_size = Vector2(2,2)
			explosion.explosion_damage = 125
			explosion.position = self.position
			get_parent().add_child(explosion)
			queue_free()

func _on_death_animation_finished(anim_name):
	queue_free()

func JUSTFUCKINGWORK() -> void:
	pass

func _on_ProjectileSpawner_timeout() -> void:
	var projectile := preload("res://scenes/boss/attacks/BallOfLight.tscn").instance()
#	projectile.position = self.position + Vector2(rand_range(-10,10),rand_range(-10,10))
	shoot.seek(0.0,true)
	shoot.play("Shoot")
	projectile.speed = 6
	get_parent().get_parent().add_child(projectile)
	projectile.global_position = self.global_position
	projectile.look_at(player.global_position)
	projectile.global_position += Vector2(40,0).rotated(projectile.rotation)
