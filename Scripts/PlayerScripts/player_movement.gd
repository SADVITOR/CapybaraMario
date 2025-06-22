extends CharacterBody2D

@export var speed: float = 150.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export var base_jump_velocity: float = -350.0
@export var max_jump_height_boost: float = -200.0
@export var max_jump_press_time: float = 0.2

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false
var jump_press_timer: float = 0.0

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta: float):
	var direction: float = Input.get_axis("p_left", "p_right")
	var jumpInput = Input.is_action_just_pressed("p_up")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false
		
	if jumpInput and is_on_floor():
		velocity.y = base_jump_velocity
		is_jumping = true
		jump_press_timer = 0.0
	
	if is_jumping:
		if jumpInput and jump_press_timer < max_jump_press_time:
			jump_press_timer += delta
			velocity.y = base_jump_velocity + (max_jump_height_boost * (jump_press_timer / max_jump_press_time))
		else:
			is_jumping = false
		
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
