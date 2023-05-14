extends KinematicBody2D

export(int) var health := 100
export(int) var defence := 0
export(int) var damage_amount := 10
export(float) var max_speed := 50.0
export(bool) var dont_damage
export var path_to_player := NodePath()

var velocity := Vector2()
export(bool) var detected_player := false

onready var agent: NavigationAgent2D = $NavigationAgent2D
onready var player := $"../../../Player"
onready var timer = $Timer

func _ready():
	ready_naviagtion()

func _process(delta):
	health_handler()

func damage(amount) -> void:
	health -= amount - defence
	print(self.get_name()," ",health)
	$Blood.restart()

func health_handler():
	if health <= 0:
		$CollisionShape2D.disabled = true
		$DamageHitbox/CollisionShape2D.disabled = true

#shush up
func ready_naviagtion():
	agent.set_target_location(player.global_position)
	timer.connect("timeout",self,"update_pathfinding")

#navgation
func navigation(delta):
	if health > 0 and detected_player:	
		if agent.is_navigation_finished():
			return
		
		var direction := global_position.direction_to(agent.get_next_location())
		
		var desired_velocity := direction * max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		
		velocity = move_and_slide(velocity)
		self.rotation = velocity.angle()

func _physics_process(delta):
	navigation(delta)

func update_pathfinding():
	agent.set_target_location(player.global_position)

func _on_DamageHitbox_area_entered(area):
	if area.get_name() == "HurtHitbox" and health > 0:
		if !"dont_damage" in area.get_parent():
			area.get_parent().damage(damage_amount)

func _on_DetectionRange_area_entered(area):
	if area.get_name() == "intArea":
		detected_player = true
