extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0
@export var jump_velocity: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Referencia al nodo de animaciones (asegúrate de que se llama así o ajústalo)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Dirección horizontal
	var direction := Input.get_axis("ui_left", "ui_right")

	# 4. Movimiento con aceleración y fricción
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# --- 5. GESTIÓN DE SPRITES Y ANIMACIONES ---
	
	# Cambiar la orientación horizontal (gira el sprite a la izquierda o derecha)
	if direction > 0:
		animated_sprite.flip_h = false  # Mira hacia la derecha
	elif direction < 0:
		animated_sprite.flip_h = true   # Mira hacia la izquierda (espejo)

	# Seleccionar qué animación reproducir según el estado físico
	if not is_on_floor():
		# Si está en el aire, diferenciamos si sube (salto) o baja (caída)
		if velocity.y < 0:
			animated_sprite.play("brincar")
		else:
			animated_sprite.play("Caer")
	else:
		# Si está en el suelo
		if direction != 0:
			animated_sprite.play("caminar")
		else:
			animated_sprite.play("quietito")

	# 6. Ejecutar movimiento
	move_and_slide()
	
