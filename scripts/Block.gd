extends RigidBody2D

class_name Block, "res://sprites/woodblock.png"

export(bool) var dont_spawn := false
var placing := true
var rigid := self

func _process(delta):
	placingBlock()

func placingBlock():
	if !dont_spawn:
		#placing
		if placing == true:
			Globals.slot1held = false
			Globals.slot2held = false
			Globals.slot3held = false
			Globals.physgunPicking = false
			rigid.position = get_global_mouse_position()
			if Input.is_action_just_released("left_click"):
#				if animsprite != null and carObject != null and isOurple == true:
#					animsprite.play()
#					enerporal.play()
				placing = false
				collisionbox.disabled = false
				if Globals.phys == true:
					rigid.mode = RigidBody2D.MODE_RIGID
