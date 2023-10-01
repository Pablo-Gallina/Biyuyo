extends Control

func _physics_process(_delta):	
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://assets/scenes/levels/Level_1.tscn")
