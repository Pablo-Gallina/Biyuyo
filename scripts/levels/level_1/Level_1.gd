extends Node2D

var level = 0
export var enemy: PackedScene

const enemys_count = 4

func _ready():
	randomize()
	spawn_enemies()

func _process(delta):
	if $enemy_container.get_child_count() == 0:
		level += 1
		spawn_enemies()

func spawn_enemies():
	for index in range(enemys_count + level):
		var enemy_instance = enemy.instance()
		enemy_instance.position = Vector2(rand_range(200, 600), rand_range(100, 400))
		$enemy_container.add_child(enemy_instance)
