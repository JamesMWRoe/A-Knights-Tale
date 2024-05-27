extends Area2D

signal checkpoint_activated

@onready var sprite = $AnimatedSprite2D

func activate():
	sprite.play("Active")

func deactivate():
	sprite.play("Inactive")

func _on_body_entered(body):
	print('checkpoint activated')
	checkpoint_activated.emit(self)
