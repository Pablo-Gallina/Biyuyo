extends Node2D

func _physics_process(_delta):	
	if Input.is_action_pressed("esc"):
		get_tree().change_scene("res://assets/scenes/menu/menu.tscn")
