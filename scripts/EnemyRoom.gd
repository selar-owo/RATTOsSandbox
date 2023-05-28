extends Node2D

onready var spawn_area: Area2D = $SpawnArea
onready var enemies: Node2D = $Enemies
onready var navigation_2d := $"../../Enemies"
var area_entered:bool = false

"""
ALL ENEMIES

---
ProducerOfCool

POCmelee
POCranged
POCshotgun
POCfast

---

AllInOne

AIOangel
AIOkneecaps

---

"""

func _ready() -> void:
	if !get_name() == "BossArea":
		spawn_area.connect("area_entered",self,"_spawn_enemies")

func _spawn_enemies(idontfuckingknow) -> void:
	if !area_entered:
		area_entered = true
		for i in enemies.get_children():
			var pos = i.global_position
			var type = i.get_name()
			summon_enemy(type,pos,navigation_2d)
			yield(get_tree().create_timer(0.1),"timeout")

func summon_enemy(type,gpos,child) -> void:
	var enemy_obj
	
	if "POCmelee" in type:
		enemy_obj = preload("res://scenes/boss/minions/SoCoolMinion.tscn").instance()
		enemy_obj.global_position = gpos
		enemy_obj.health = 60
		enemy_obj.max_speed = 150
		enemy_obj.defence = 0
		child.add_child(enemy_obj)
	if "POCranged" in type:
		enemy_obj = preload("res://scenes/boss/minions/SoCoolRanger.tscn").instance()
		enemy_obj.global_position = gpos
		child.add_child(enemy_obj)
	if "POCfast" in type:
		enemy_obj = preload("res://scenes/boss/minions/SoCoolMinion.tscn").instance()
		enemy_obj.global_position = gpos
		enemy_obj.health = 20
		enemy_obj.max_speed = 350
		enemy_obj.defence = -1
		enemy_obj.scale = Vector2(0.1,0.1)
		child.add_child(enemy_obj)
