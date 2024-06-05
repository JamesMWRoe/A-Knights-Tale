extends Area2D

@export var level_manager: Node

func _on_body_entered(body):
	level_manager.handle_level_complete()
