extends KinematicBody2D

export var health := 20
export var defence := 0
export var damage:int
export var speed = 12
onready var rocket_area: Area2D = $RocketArea
onready var ui := $"../UI"
onready var player := $"../Player"
onready var glow_thing: Sprite = $GlowThing
onready var spawn: Particles2D = $Spawn
var rocket_exploded:bool
var parried := false

var velocity = Vector2()

func _process(delta: float) -> void:
	moving()

func _ready() -> void:
	damage = 20
	spawn.set_emitting(true)

func moving():
	velocity = Vector2(0,0)
	velocity = Vector2(speed,0).rotated(rotation)
	move_and_collide(velocity)

func _explode(size,damage_amount,ishandgun) -> void:
	if !rocket_exploded:
		rocket_exploded = true
		var explosion = ResourceLoader.load("res://scenes/otherstuffidk/Explosion.tscn").instance()
		explosion.explosion_size = size
		explosion.explosion_damage = damage_amount
		explosion.explosion_weapon_type = 6
		explosion.parried = parried
		explosion.position = self.position
		explosion.modulate = Color(2,2,2,1)
		get_parent().add_child(explosion)
		queue_free()

func parried() -> void:
	speed += 8
	damage += 20
	player.health += 5
	rotation_degrees = player.rotation_degrees
	parried = true
	ui.parry()

func damage(attack:Attack) -> void:
	health -= attack.amount
#	if health <= 0:
#		_explode(Vector2(2,2),damage,false)

func _on_HurtHitbox_body_entered(body: Node) -> void:
	if body.get_name() != "Foliage" or body.get_name() != "Water":
		if body.get_name() != "SoCool" or parried or !body.get_parent().has_method("JUSTFUCKINGWORK"):
			print(body)
			_explode(Vector2(2,2),damage,false)
