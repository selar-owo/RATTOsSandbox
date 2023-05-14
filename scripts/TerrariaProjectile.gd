extends KinematicBody2D

export var speed := 10
var velocity := Vector2()

func _process(delta: float) -> void:
	move()

func move() -> void:
	velocity = Vector2()
	velocity += Vector2(speed,0).rotated(rotation)
	
	move_and_collide(velocity)

func _on_TerrariaArea_area_entered(area: Area2D) -> void:
	if area.get_name() == "HurtHitbox" and area.get_parent().get_name() != "Player":
		var attack = Attack.new()
		attack.attack_point = area.get_parent().position
		attack.amount = 25
		attack.weapon_type = 4
		show_damage_number(area.get_parent().defence,attack)
		area.get_parent().damage(attack)

func show_damage_number(defence,attack:Attack):
	var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
	if defence >= attack.amount:
		damagenumber.damage_number = 1
	else:
		damagenumber.damage_number = attack.amount - defence
	damagenumber.position = attack.attack_point
	get_parent().add_child(damagenumber)
