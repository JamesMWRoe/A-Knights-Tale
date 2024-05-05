extends Area2D

func _ready():
	print('coin added')

func _on_body_entered(_body):
	print('coin picked up')
	%GameManager.add_to_score()
	queue_free()
