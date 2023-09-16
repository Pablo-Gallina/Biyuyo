extends KinematicBody2D

export var speed : float = 100
export var min_distance: float = 40

func _process(delta):
	motion_ctrl()

func motion_ctrl() -> void:
	var input_vector = get_input_vector_keyboard()
	var velocity = input_vector * speed
	move_and_slide(velocity)

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
