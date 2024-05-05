extends Node

@onready var player_camera = $"../Player/PlayerCamera"
@onready var worldbound_left = $"../WorldBoundary/BoundLeft"
@onready var worldbound_right = $"../WorldBoundary/BoundRight"

func _ready():
	player_camera.limit_left = worldbound_left.position.x
	player_camera.limit_right = worldbound_right.position.x

