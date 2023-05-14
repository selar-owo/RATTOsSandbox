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
		var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
		var damage = round(explosion_damage / ((area.get_parent().position.distance_to(position) + 0.1) / 20))
		var attack = Attack.new()
		attack.amount = damage
		attack.weapon_type = explosion_weapon_type
		attack.attack_point = area.get_parent().position
		if explosion_weapon_type != 6 or parried:
			damagenumber.damage_number = damage
			damagenumber.position = area.get_parent().position
			attack.weapon_type = 3
			self.get_parent().add_child(damagenumber)
		area.get_parent().damage(attack)

func _on_DeleteTimer_timeout() -> void:
	queue_free()
