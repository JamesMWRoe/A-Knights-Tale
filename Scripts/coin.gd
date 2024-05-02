extends Area2D

signal picked_up

func _ready():
	print('coin added');

func _on_body_entered(body):
	print('coin picked up');
	picked_up.emit();
	queue_free();
