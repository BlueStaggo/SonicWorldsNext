extends "res://Scripts/Player/State.gd"


func _physics_process(delta):
	parent.animator.play("hurt")
	# gravity
	parent.movement.y += 0.1875/GlobalFunctions.div_by_delta(delta)
	
	# exit if checked floor
	if parent.ground and parent.movement.y >= 0:
		parent.movement.x = 0
		parent.set_state(parent.STATES.NORMAL)
