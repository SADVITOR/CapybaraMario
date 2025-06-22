extends CharacterBody2D

func _dead_enemy_trigger_enter(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
