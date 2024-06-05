extends Node

@onready var player_camera = $"../Player/PlayerCamera"
@onready var worldbound_left = $"../WorldBoundary/BoundLeft"
@onready var worldbound_right = $"../WorldBoundary/BoundRight"

func _ready():
	player_camera.limit_left = worldbound_left.position.x
	player_camera.limit_right = worldbound_right.position.x
	player_camera.limit_bottom = 48

func handle_level_complete():
	get_tree().change_scene_to_file("res://Scenes/Levels/game_end_scene.tscn")
