extends KinematicBody2D

export var explosion_size := Vector2(1,1)
export var explosion_damage := 80
export var explosion_weapon_type := 3
export var parried := false
onready var explosion_effect: CPUParticles2D = $ExplosionEffect
onready var player: KinematicBody2D = $"../Player"
onready var light_2d: Light2D = $Light2D

func _ready() -> void:
	scale = explosion_size
	explode()

func explode() -> void:
	explosion_effect.set_emitting(true)
	yield(get_tree().create_timer(0.1),"timeout")
	$ExplosionEffect/ExplosionArea/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Flash")

func _on_ExplosionArea_area_entered(area: Area2D) -> void:
	if area.get_name() == "HurtHitbox":
		#add velocity
		var the_parent := area.get_parent()
		var damage = round(explosion_damage / ((the_parent.position.distance_to(position) + 0.1) / 20))
#		var the_calculation = ((self.position - the_parent.position) * -1) * damage / 10
#		if the_parent is RigidBody2D:
#			the_parent.linear_velocity += the_calculation
#		elif the_parent is KinematicBody2D:
#			the_parent.velocity += the_calculation
		
		var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
		var attack = Attack.new()
		attack.amount = damage
		attack.weapon_type = explosion_weapon_type
		attack.attack_point = the_parent.position
		if explosion_weapon_type != 6 or parried:
			damagenumber.damage_number = damage
			damagenumber.position = the_parent.position
			attack.weapon_type = 3
			self.get_parent().add_child(damagenumber)
		area.get_parent().damage(attack)

func _on_ExplosionArea_body_entered(body):
	var damage = round(explosion_damage / ((body.position.distance_to(position) + 0.1) / 20))
	var the_calculation = ((self.position - body.position) * -1) * (damage * 5) / 10
	if body is RigidBody2D:
		body.linear_velocity += the_calculation
	elif body is KinematicBody2D:
		body.velocity += the_calculation

func _on_DeleteTimer_timeout() -> void:
	queue_free()

