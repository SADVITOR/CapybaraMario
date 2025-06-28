extends CharacterBody2D

# ----- GRAVITY -----
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# ----- PLAYER SPEED -----
@export var player_speed: float = 50.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

# ----- PLAYER SPRITES -----
@export var sprite2D: Sprite2D
@export var sprites: Array[Texture2D]

# ----- CHECKS -----
var player_death: bool = false
var player_fall: bool = false
var is_jumping: bool = false

# ----- PLAYER JUMP -----
@export var base_jump_velocity: float = -10.0
@export var max_jump_height_boost: float = -10.0
@export var max_jump_press_time: float = 0.2
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0

# ----- PLAYER DEATH ACTION -----
@export var death_jump_height: float = 30.0
var death_timer: float = 0.0
var death_initial_time: float = 1.2

# ----- PLAYER STATES -----
enum PlayerStates {
	FREE,
	DEAD,
	ENTER_PIPE
}

var current_state = PlayerStates.FREE

func _ready() -> void:
	current_state = PlayerStates.FREE
	player_death = false

func _physics_process(delta: float) -> void:
	match current_state:
		PlayerStates.FREE:
			_player_movement(delta)
		PlayerStates.DEAD:
			_player_dead(delta)
		PlayerStates.ENTER_PIPE:
			pass

func _player_movement(_delta: float):
	var _direction: float = Input.get_axis("p_left", "p_right")
	var _jump_just_pressed: bool = Input.is_action_just_pressed("p_up")
	var _jump_is_pressed: bool = Input.is_action_pressed("p_up")

	if _direction:
		velocity.x = move_toward(velocity.x, _direction * player_speed, acceleration * _delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * _delta)

	move_and_slide()

func _player_dead(_delta: float):
	pass


# 	# Aplicar gravidade
# 	if not is_on_floor():
# 		velocity.y += gravity * delta
# 		coyote_timer -= delta
# 	else:
# 		is_jumping = false
# 		coyote_timer = coyote_time



# 	# Movimento horizontal: Aceleração e Fricção
# 	if direction:
# 		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
# 	else:
# 		velocity.x = move_toward(velocity.x, 0, friction * delta)

# 	move_and_slide()

# func _player_dead(delta: float):
# 	if not death:
# 		death = true
# 		# Desabilitar a colisão para que ele não bata no chão ou em paredes
# 		set_collision_mask_value(1, false) # Ajuste 1 para a layer do chão/plataformas
# 		set_collision_layer_value(1, false) # Ajuste 1 para a layer do player
		
# 		velocity.y = -player_death_jump # Impulso para cima
# 		velocity.x = 0 # Para qualquer movimento horizontal
# 		death_timer = death_time_initial
# 		player_sprite.texture = sprites[0]
# 		z_index = 0
# 		player_falling_after_death = false # Resetar para garantir que o pulo aconteça

# 	# Aplicar gravidade continuamente
# 	velocity.y += gravity * delta
	
# 	# Usamos position para mover manualmente e ignorar colisões no início da morte
# 	# Aumentar a velocidade do movimento vertical para que o pulo seja visível
# 	position += velocity * delta 

# 	if death_timer > 0:
# 		death_timer -= delta
# 	else:
# 		# Após o tempo inicial, garantimos que a queda continue
# 		player_falling_after_death = true
# 		z_index = -10 # Mudar o z_index para mostrar que está atrás de algo, se desejar

# 	# Se você quiser que o jogador seja removido após cair para fora da tela, pode adicionar:
# 	# if position.y > get_viewport_rect().size.y + 100: # Exemplo: 100 pixels abaixo da tela
# 	# 	queue_free() # Remove o nó do jogo

# func _on_damage_trigger_area_entered(area: Area2D) -> void:
# 	if area.is_in_group("Enemy"):
# 		current_state = PlayerState.DEAD
