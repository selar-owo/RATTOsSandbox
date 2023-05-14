extends KinematicBody2D

onready var player = $"../../Player"

func _ready():
	self.global_position = player.global_position + Vector2(rand_range(-300,300),rand_range(-300,300))
	look_at(player.global_position)
	randomize()

func _on_DamageArea_area_entered(area):
	if area.get_name() == "HurtHitbox" and !"minin" in area.get_parent():
		var attack = Attack.new()
		attack.amount = 30
		attack.attack_point = area.get_parent().position
		attack.weapon_type = 6
		area.get_parent().damage(attack)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
