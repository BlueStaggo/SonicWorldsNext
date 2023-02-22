class_name EnemyBase extends CharacterBody2D

enum ELEMENT {NORMAL, FIRE, ELEC, WATER}
@export var damageType: ELEMENT = ELEMENT.NORMAL
var playerHit = []

# XXX Why do we ever need to set a zero velocity?
#var velocity = Vector2.ZERO
var Explosion = preload("res://Entities/Misc/BadnickSmoke.tscn")
var Animal = preload("res://Entities/Misc/Animal.tscn")
var forceDamage = false
var defaultMovement = true

signal destroyed

func _process(delta):
	# checks if player hit has players inside
	if (playerHit.size() > 0):
		# loop through players as i
		for i in playerHit:
			# check if damage entity is checked or supertime is bigger then 0
			if (i.get_collision_layer_value(19) or i.supTime > 0 or forceDamage):
				# check player is not checked floor
				if !i.ground:
					# subtract from velocity if velocity is less then 0 or below enemy (use current velocity to avoid clipping issues)
					if (i.movement.y < 0 or i.global_position.y-(i.velocity.y*delta) > global_position.y):
						i.movement.y -= 60*sign(i.velocity.y)
					else:
					# reverse vertical velocity
						i.movement.y = -i.velocity.y
						if i.shield == i.SHIELDS.BUBBLE:
							i.emit_enemy_bounce()
				# destroy
				Global.add_score(global_position,Global.SCORE_COMBO[min(Global.SCORE_COMBO.size()-1,i.enemyCounter)])
				i.enemyCounter += 1
				destroy()
				# cut the script short
				return false
			# if destroying the enemy fails and hit player exists then hit player
			if (i.has_method("hit_player")):
				i.hit_player(global_position,damageType)
	# move
	if defaultMovement:
		translate(velocity*delta)

func _on_body_entered(body):
	# add to player list
	if (!playerHit.has(body)):
		playerHit.append(body)


func _on_body_exited(body):
	# remove_at from player list
	if (playerHit.has(body)):
		playerHit.erase(body)

func _on_DamageArea_area_entered(area):
	# damage checking
	if area.get("parent") != null and area.get_collision_layer_value(19):
		if !playerHit.has(area.parent):
			forceDamage = true
			playerHit.append(area.parent)

func destroy():
	emit_signal("destroyed")
	# create explosion
	var explosion = Explosion.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	# create animal
	var animal = Animal.instantiate()
	animal.animal = Global.animals[round(randf())]
	get_parent().add_child(animal)
	animal.global_position = global_position
	# free node
	queue_free()



