extends Node2D

const SPEED = 60
var direction = 1
@onready var sprite = $AnimatedSprite2D

@export var start_right = true
@export var is_moving = true

func _ready():
	if not start_right:
		sprite.flip_h = true
		direction = -1

func _process(delta):
	if not is_moving:
		return
	
	if $RayCastRight.is_colliding():
		direction = -1
		sprite.flip_h = true
	if $RayCastLeft.is_colliding():
		direction = 1
		sprite.flip_h = false
	
	if not $RayCastDownLeft.is_colliding():
		direction = 1
		sprite.flip_h = false
		
	if not $RayCastDownRight.is_colliding():
		direction = -1
		sprite.flip_h = true
		
	position.x += direction * SPEED * delta
