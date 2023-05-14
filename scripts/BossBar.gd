extends TextureProgress

export var health:int
export var _name:String
export var boss_icon:Resource
onready var boss_bar: TextureProgress = $"."
onready var health_label: Label = $HealthLabel
onready var name_label: Label = $NameLabel
onready var boss_icon_node: TextureRect = $BossIcon
var max_health:int

func _ready() -> void:
	name_label.text = _name
	boss_icon_node.set_texture(boss_icon)
	boss_bar.max_value = max_health

func _process(delta: float) -> void:
	boss_bar.value = health
	health_label.text = str(health,"/",max_health)
