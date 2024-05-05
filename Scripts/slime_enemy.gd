extends Node2D

const SPEED = 60
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCastRight.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	if $RayCastLeft.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
	position.x += direction * SPEED * delta
