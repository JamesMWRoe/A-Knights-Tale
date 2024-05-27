extends AnimatableBody2D

var is_falling = false

# when a body enters the small area at the top of the block, it should begin to fall
func _on_body_entered(body):
	if is_falling:
		return
	is_falling = true
	$FallTimer.start()
	$Sprite2D/AnimationPlayer.play('ReadyToFall')

func _on_fall_timer_timeout():
	$CollisionShape2D.disabled = true
	self.modulate = Color(1, 1, 1, 0.5)
	$ResetTimer.start()

func _on_reset_timer_timeout():
	$CollisionShape2D.disabled = false
	self.modulate = Color(1, 1, 1, 1)
	is_falling = false
