extends CanvasLayer

export var player_node : NodePath
onready var player = get_node(player_node)

func _process(_delta):
	$TextureProgress.value = player.healt
