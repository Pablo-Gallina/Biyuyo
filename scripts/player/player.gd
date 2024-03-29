extends KinematicBody2D

export var min_distance: float = 40

export var speed : float = 100
export var dash_speed: float = 800 # Velocidad del dash
export var dash_duration: float = 0.2  # Duración del dash en segundos
export var dash_cooldown: float = 3.0  # Tiempo de espera entre dashes en segundos
export var healt = 100
export var dash_animation_node: PackedScene
var can_dash: bool = true  # Indica si se puede hacer un dash
var dash_timer: float = 0.0  # Contador de tiempo para el dash

# animation variables
var is_running : bool = false
var facing_left : bool = false

func _process(delta):
	motion_ctrl()
	set_player_animation()
	handle_dash(delta)

func motion_ctrl() -> void:
	var input_vector = get_input_vector_mouse()
	var velocity = input_vector * speed
	
	if velocity != Vector2.ZERO:
		is_running = true
	else:
		is_running = false
	
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false
	
	move_and_slide(velocity)

func set_player_animation() -> void:
	if is_running:
		$spr_player.play("run")
	else:
		$spr_player.play("idle")
	
	if facing_left:
		$spr_player.flip_h = true
	else:
		$spr_player.flip_h = false
	
	if !can_dash:
		$spr_player.play("dash")

func get_input_vector_keyboard() -> Vector2:
	var input_vector = Vector2.ZERO

	# Obtener la entrada del teclado
	input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	return input_vector.normalized()

func get_input_vector_mouse() -> Vector2:
	var mouse_position = get_global_mouse_position()
	var player_position = global_transform.origin
	var direction = mouse_position - player_position
	var distance = direction.length()

	if distance > min_distance:
		direction = direction.normalized()
	else:
		direction = Vector2.ZERO

	return direction

func handle_dash(delta: float) -> void:
	var input_vector = get_input_vector_mouse()
	var dash_direction = input_vector.normalized()
	if can_dash and Input.is_action_just_pressed("dash"):
		# Calcula la dirección actual del personaje y aplica el dash
		if input_vector != Vector2.ZERO:
			dash_timer = dash_duration
			can_dash = false
	if dash_timer > 0:
		# Continuar con el dash durante dash_duration
		var dash_velocity = dash_direction * dash_speed
		move_and_slide(dash_velocity)
		dash_timer -= delta
	else:
		# Reiniciar el contador y habilitar el dash después del tiempo de espera
		dash_timer = 0.0
		can_dash = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy") and can_dash:
#		print("ENEMY your  deat")
		$spr_player.play("hit")
		damage_ctrl(20)

	if body.is_in_group("enemy") and !can_dash:
#		print("enemy eleminded")
		if body.has_method("eliminate_enemy"):
			body.eliminate_enemy()
			if healt < 100:
				healt += 5

func damage_ctrl(damage: int) -> void:
	healt -= damage
	
# Dashing animation
func add_dash_animation():
	if dash_animation_node != null:
		var dash_animation_instance = dash_animation_node.instance()
		if dash_animation_instance != null:
			dash_animation_instance.set_property($spr_player.global_position, $spr_player.scale)
			
			# Determina si el jugador está mirando hacia la izquierda o la derecha
			if facing_left:
				# Si el jugador mira hacia la izquierda, voltea el sprite horizontalmente
				dash_animation_instance.flip_h = true
			else:
				# Si el jugador mira hacia la derecha, asegúrate de que el sprite no esté volteado
				dash_animation_instance.flip_h = false
			
			get_tree().current_scene.add_child(dash_animation_instance)


func _on_dash_animation_timer_timeout():
	if !can_dash:
		add_dash_animation()
