extends Node2D

onready var player := $"../../Player"

onready var health_bars := $HealthBars
onready var all_health_styles := [$Bar, $Heart, $Plus, $Number]
onready var current_health_bar
onready var current_shield_bar
onready var current_health_label

func _ready():
	reload_health_style()

func _process(delta):
	health_bar_handler()

func reload_health_style():
	for i in all_health_styles:
		i.hide()
	
	match SaveSettings.load_cfg("VisualsAudio","HealthBarStyle"):
		"bar":
			all_health_styles[0].show()
			current_health_bar = $Bar/HealthBar
			current_shield_bar = $Bar/ShieldBar
			current_health_label = $Bar/HealthCount
		"heart":
			all_health_styles[1].show()
			current_health_bar = $Heart/HealthBar
			current_shield_bar = $Heart/ShieldBar
			current_health_label = $Heart/HealthCount
		"plus":
			all_health_styles[2].show()
			current_health_bar = $Plus/HealthBar
			current_shield_bar = $Plus/ShieldBar
			current_health_label = $Plus/HealthCount
		"number":
			all_health_styles[3].show()
			current_health_bar = $Number/HealthBar
			current_shield_bar = $Number/ShieldBar
			current_health_label = $Number/HealthCount
	current_shield_bar.max_value = SaveSettings.load_cfg("PhysicsStuff","MaxHealth") - 100

func player_damaged():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	if round(player.health) > 100 and SaveSettings.load_cfg("VisualsAudio","HealthBarStyle") == "bar":
		tween.tween_property(current_health_bar,"self_modulate",Color(0.458824, 0.466667, 0.623529),1)
	elif round(player.health) <= 100 and SaveSettings.load_cfg("VisualsAudio","HealthBarStyle") == "bar":
		tween.tween_property(current_health_bar,"self_modulate",Color(1, 1, 1),1)

func health_bar_handler():
	var player_shield = player.health - (SaveSettings.load_cfg("PhysicsStuff","MaxHealth") - (SaveSettings.load_cfg("PhysicsStuff","MaxHealth") - 100))
	current_shield_bar.value = lerp(current_shield_bar.value,player_shield,0.8)
	current_health_bar.value = lerp(current_health_bar.value,player.health,0.8)
	current_health_label.text = str(round(player.health))
