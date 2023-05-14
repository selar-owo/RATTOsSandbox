extends KinematicBody2D

export(int) var damage_number
var velocity = Vector2()

func _ready():
	position.y += -10
	$Label.text = str(damage_number)

func _process(delta: float) -> void:
	funny()

func funny():
	rotation_degrees += rand_range(-1,1)
	velocity += Vector2(rand_range(-1,1),rand_range(-1,1))

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
