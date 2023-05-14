extends KinematicBody2D

export var health := 20
export var defence := 0
export var damage:int
export var speed = 7
onready var rocket_area: Area2D = $RocketArea
onready var ui := $"../UI"
onready var player := $"../Player"
var rocket_exploded:bool

var velocity = Vector2()

func _process(delta: float) -> void:
	moving()

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
		explosion.position = self.position
		if ishandgun:
			explosion.modulate = Color(0.5,0,0,1)
		get_parent().add_child(explosion)
		queue_free()

func parried() -> void:
	speed += 8
	damage += 10
	rotation_degrees = player.rotation_degrees
	ui.parry()

func damage(attack:Attack) -> void:
	health -= attack.amount
	if health <= 0:
		_explode(Vector2(2,2),damage,false)
	if attack.weapon_type == 0:
		_explode(Vector2(2.5,2.5),damage * 2,true)
		ui.parry()
#
#func _on_RocketArea_area_entered(area: Area2D) -> void:
#	if area.get_name() == "HurtHitbox":
#		_explode(Vector2(2,2),damage,false)

func _on_HurtHitbox_body_entered(body: Node) -> void:
	if body.get_name() != "Foliage":
		print(body)
		_explode(Vector2(2,2),damage,false)
