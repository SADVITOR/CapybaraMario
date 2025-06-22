extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export var base_jump_velocity: float = -50.0
@export var max_jump_height_boost: float = -25.0
@export var max_jump_press_time: float = 0.2
@export var coyote_time: float = 0.1 # New: Duration for coyote frames
@export var player_death_jump: float = 30.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false
var jump_press_timer: float = 0.0
var coyote_timer: float = 0.0 # New: Timer for coyote frames
var player_dead: bool = false

enum PlayerState {
	NORMAL,
	DEAD,
	ENTER_PIPE
}

var current_state: PlayerState = PlayerState.NORMAL

func _ready() -> void:
	current_state = PlayerState.NORMAL

func _physics_process(delta: float) -> void:
	match current_state:
		PlayerState.NORMAL:
			_player_movement(delta)
		PlayerState.DEAD:
			pass
		PlayerState.ENTER_PIPE:
			pass

func _player_movement(delta: float):
	var direction: float = Input.get_axis("p_left", "p_right")
	var jump_just_pressed: bool = Input.is_action_just_pressed("p_up")
	var jump_is_pressed: bool = Input.is_action_pressed("p_up") # New: For variable jump height

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta # Decrement coyote timer when in air
	else:
		is_jumping = false
		coyote_timer = coyote_time # Reset coyote timer when on floor

	# Initial jump
	if jump_just_pressed:
		if is_on_floor() or coyote_timer > 0: # Allow jump if on floor or within coyote time
			velocity.y = base_jump_velocity
			is_jumping = true
			jump_press_timer = 0.0
			coyote_timer = 0.0 # Consume coyote time on jump

	# Variable jump height ("pressure" jump)
	if is_jumping:
		# Check if jump button is still pressed AND within the allowed press time
		if jump_is_pressed and jump_press_timer < max_jump_press_time:
			jump_press_timer += delta
			# Calculate the additional jump velocity based on how long the button is pressed
			velocity.y = base_jump_velocity + (max_jump_height_boost * (jump_press_timer / max_jump_press_time))
		else:
			is_jumping = false # Stop boosting jump if button released or max time reached

	# Horizontal movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _player_dead_animation():
	velocity = Vector2(0, player_death_jump)
	set_collision_mask_value(1, false)
	z_index = 10
	
func _player_enter_pipe():
	pass
