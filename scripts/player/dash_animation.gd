extends Sprite

func _ready():
	dashing()
	
func set_property(tx_pos, tx_scale):
	position = tx_pos
	scale = tx_scale

func dashing():
	var tween = Tween.new()
	add_child(tween)  # Agrega el Tween como un nodo hijo para que se procese automáticamente
	
	tween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 0), 0.20, Tween.TRANS_LINEAR)
	tween.connect("tween_completed", self, "_on_tween_completed")

	tween.start()

# Este método se llama cuando el tween ha terminado
func _on_tween_completed(object_id, key):
	queue_free()
