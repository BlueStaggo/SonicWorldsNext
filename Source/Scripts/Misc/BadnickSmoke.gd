extends AnimatedSprite2D

var animFinished = false

func _ready():
	# XXX Does this not autoplay by virtue of being an AnimatedSprite2D?
	#playing = true
	pass

func _on_animation_finished():
	animFinished = true
	visible = false
	if (!$Explode.playing):
		queue_free()

func _on_Explode_finished():
	if (animFinished):
		queue_free()
