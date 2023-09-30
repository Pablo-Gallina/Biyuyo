extends KinematicBody2D

var player = null
var movment = Vector2.ZERO
var speed = 150

func _physics_process(delta):
	movment = Vector2.ZERO
	
	if player != null:
		movment = position.direction_to(player.position)
	else:
		movment = Vector2.ZERO
		
	movment = movment.normalized() * speed
	movment = move_and_slide(movment)

func _on_Area2D_body_entered(body):
	if body != self:
		player = body

func _on_Area2D_body_exited(body):
	player  = null

func eliminate_enemy():
	queue_free()
