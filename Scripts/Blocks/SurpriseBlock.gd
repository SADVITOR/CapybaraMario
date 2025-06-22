extends StaticBody2D

@export var block_sprite: Sprite2D;
@export var block_sprite_list: Array[Texture2D]

var active: bool = false

func _ready() -> void:
	block_sprite.texture = block_sprite_list[0]

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if active == false:
			block_sprite.texture = block_sprite_list[1]
		else:
			block_sprite.texture = block_sprite_list[0]
