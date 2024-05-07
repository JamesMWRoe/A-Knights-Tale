extends CharacterBody2D

#Constants

const TILE_UNIT = 16
const JUMP_HEIGHT = 3 * TILE_UNIT
const JUMP_DISTANCE_1 = 3 * TILE_UNIT
const JUMP_DISTANCE_2 = 2 * TILE_UNIT

const MAX_RUN_SPEED = 8 * TILE_UNIT
const MAX_SPRINT_SPEED = 12 * TILE_UNIT
const GROUND_ACCELERATION = 20
const AIR_ACCELERATION = 15
const JUMP_VELOCITY = -2 * JUMP_HEIGHT * MAX_RUN_SPEED / JUMP_DISTANCE_1

const JUMP_GRAVITY = 2 * JUMP_HEIGHT * MAX_RUN_SPEED*MAX_RUN_SPEED / (JUMP_DISTANCE_1*JUMP_DISTANCE_1)
const FALL_GRAVITY = 2 * JUMP_HEIGHT * MAX_RUN_SPEED*MAX_RUN_SPEED / (JUMP_DISTANCE_2*JUMP_DISTANCE_2)

#Variables

var within_coyote_time = false
var within_jump_time = false

var is_sprinting = false

var current_gravity
var current_speed
var current_horizontal_acceleration


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		current_horizontal_acceleration = AIR_ACCELERATION
		
		if velocity.y >= 0:
			current_gravity = FALL_GRAVITY
		velocity.y += current_gravity * delta
		velocity.y = clampf(velocity.y, -300, 500);
	else:
		current_horizontal_acceleration = GROUND_ACCELERATION
		
		$CoyoteTimer.start()
		within_coyote_time = true
	
	if Input.is_action_just_pressed("jump"):
		$JumpTimer.start()
		within_jump_time = true

	# Handle jump.
	if within_jump_time and within_coyote_time:
		within_coyote_time = false
		within_jump_time = false
		current_gravity = JUMP_GRAVITY
		velocity.y = JUMP_VELOCITY
		current_horizontal_acceleration = AIR_ACCELERATION
	
	if Input.is_action_just_released("jump"):
		current_gravity = FALL_GRAVITY
		if velocity.y < 0:
			velocity.y /= 3

	# Gets input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	if direction:
		$AnimatedSprite2D.play("run")
		velocity.x += direction * current_horizontal_acceleration
		velocity.x = clampf(velocity.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	elif is_on_floor():
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, current_horizontal_acceleration)
		
	if not is_on_floor():
		$AnimatedSprite2D.play('jump')

	move_and_slide()

func bounce():
	within_jump_time = true
	within_coyote_time = true

func _on_jump_timer_timeout():
	within_jump_time = false


func _on_coyote_timer_timeout():
	within_coyote_time = false
