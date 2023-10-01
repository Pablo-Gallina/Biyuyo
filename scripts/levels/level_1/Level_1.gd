extends Node2D

var level: int = 0
var game_over: bool = false
export var enemy: PackedScene

const enemys_count = 4

func _ready():
	randomize()
	spawn_enemies()

func _process(delta):
	if $enemy_container.get_child_count() == 0:
		level += 1
		spawn_enemies()
	if level == 1:
		if $instructions != null:
			$instructions.visible = false
	print($player.healt)
	if $player.healt <= 0:
		game_over()

func spawn_enemies():
	for index in range(enemys_count + level):
		var enemy_instance = enemy.instance()
		enemy_instance.position = Vector2(rand_range(200, 600), rand_range(100, 400))
		$enemy_container.add_child(enemy_instance)

func game_over():
	game_over = true
	get_tree().change_scene("res://assets/scenes/levels/game_over.tscn")
