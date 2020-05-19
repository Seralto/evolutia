extends Area2D

export var eaten = false

func _process(delta):
	if eaten:
		queue_free()
