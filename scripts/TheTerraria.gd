extends KinematicBody2D

onready var swing_sprites: Node2D = $SwingSprites
onready var back_sprite:AnimatedSprite = $BackSprite
onready var swing_animation: AnimationPlayer = $SwingSprites/SwingAnimation
onready var sword_scale_thing: Particles2D = $SwingSprites/Sprite/SwordScaleThing
onready var surrounding_particles: Particles2D = $SwingSprites/Sprite/SurroundingParticles
onready var surrounding_particles_2: Particles2D = $SwingSprites/Sprite/SurroundingParticles2
onready var sword_hitbox: CollisionShape2D = $SwingSprites/Sprite/SwordArea/CollisionShape2D
onready var spawn_point: Node2D = $SwingSprites/Sprite/SpawnPoint
onready var swing_audio: AudioStreamPlayer = $SwingAudio
export var shoot_projectile := false

func _ready() -> void:
	setup_terraria()

func _process(delta: float) -> void:
	swing()
	shoot()

func swing() -> void:
	if Input.is_action_just_pressed("left_click") and !Globals.QmenuOpen and Globals.slot2held:
		swing_animation.play("SwingLoop")
		swing_sprites.show()
		back_sprite.hide()
		sword_hitbox.disabled = false
	if Input.is_action_just_released("left_click") or Input.is_action_just_pressed("QMenu") or !Globals.slot2held:
		swing_animation.seek(0.0,true)
		swing_animation.stop()
		swing_sprites.hide()
		back_sprite.show()
		sword_scale_thing.restart()
		surrounding_particles.restart()
		surrounding_particles_2.restart()
		sword_hitbox.disabled = true
		shoot_projectile = false
		$SwingAudio.stop()

func setup_terraria() -> void:
	Globals.slot2pic = "res://sprites/TerrariaAnimated.tres"

func shoot() -> void:
	if shoot_projectile == true:
		var proj = ResourceLoader.load("res://scenes/projectiles/TerrariaProjectile.tscn").instance()
		swing_audio.play()
		get_parent().get_parent().get_parent().add_child(proj)
		proj.global_position = spawn_point.global_position
		proj.look_at(get_global_mouse_position())
		shoot_projectile = false

func _on_SwordArea_area_entered(area: Area2D) -> void:
	if area.get_name() == "HurtHitbox" and area.get_parent().get_name() != "Player":
		var attack := Attack.new()
		attack.attack_point = area.get_parent().position
		attack.amount = 50
		attack.weapon_type = 5
		show_damage_number(area.get_parent().defence,attack)
		area.get_parent().damage(attack)

func show_damage_number(defence,attack:Attack):
	var damagenumber = load("res://scenes/UIs/DamageNumber.tscn").instance()
	if defence >= attack.amount:
		damagenumber.damage_number = 1
	else:
		damagenumber.damage_number = attack.amount - defence
	damagenumber.position = attack.attack_point
	self.get_parent().get_parent().get_parent().add_child(damagenumber)
