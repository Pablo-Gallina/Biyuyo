extends KinematicBody2D

export var speed : float = 100
export var min_distance: float = 40

# animation variables
var is_running : bool = false
var facing_left : bool = false

func _process(delta):
	motion_ctrl()
	set_player_animation()

func motion_ctrl() -> void:
	var input_vector = get_input_vector_keyboard()
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
		$spr_player2.play("run")
	else:
		$spr_player2.play("idle")
	
	if facing_left:
		$spr_player2.flip_h = true
	else:
		$spr_player2.flip_h = false

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
