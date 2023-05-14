extends Particles2D

onready var blood: Particles2D = $"."
onready var smaller_blood: Particles2D = $SmallerBlood
onready var timer: Timer = $Timer
export var blood_size:Vector2 = Vector2(1,1)
export var blood_amount:int = 16
export var heal_amount:int = 5

func _ready() -> void:
	emit_blood()

func emit_blood() -> void:
	self.show()
	blood.amount = blood_amount
	smaller_blood.amount = blood_amount
	self.scale = blood_size
	blood.set_emitting(true)
	smaller_blood.set_emitting(true)
	add_blood_decal()

func add_blood_decal() -> void:
	var decal = preload("res://scenes/otherstuffidk/BloodDecal.tscn").instance()
	decal.position = position
	decal.scale = blood_size
	self.get_parent().add_child(decal)

func _on_Timer_timeout() -> void:
	queue_free()

func _on_HealArea_area_entered(area: Area2D) -> void:
	if area.get_parent().get_name() == "Player":
		print("hey")
		var player := area.get_parent()
		$HealArea/CollisionShape2D.disabled = true
		player.health += heal_amount / 2.5
#		if (player.health + heal_amount) > 100:
#			player.health += clamp(heal_amount,0,heal_amount - (player.health - 100))
##			player.health += (heal_amount - (player.health - 100))
#		else:
#			player.health += heal_amount
