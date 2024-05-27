extends Node2D

const SPEED = 60
var direction = 1
var left = -1
var right = 1
@onready var sprite = $AnimatedSprite2D

@export var start_right = true
@export var is_moving = true
@export var is_upside_down = false

func _ready():
	
	sprite.frame = randi_range(0, 3)
	
	if not start_right:
		sprite.flip_h = true
		direction = -1
	
	if is_upside_down:
		left = 1
		right = -1

func _process(delta):
	if not is_moving:
		return
	
	if $RayCastRight.is_colliding():
		direction = left
		sprite.flip_h = true
	if $RayCastLeft.is_colliding():
		direction = right
		sprite.flip_h = false
	
	if not $RayCastDownLeft.is_colliding():
		direction = right
		sprite.flip_h = false
		
	if not $RayCastDownRight.is_colliding():
		direction = left
		sprite.flip_h = true
		
	position.x += direction * SPEED * delta
