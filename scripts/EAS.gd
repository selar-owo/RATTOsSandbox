extends Node2D

func _on_VideoPlayer_finished() -> void:
	get_tree().quit()
