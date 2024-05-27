extends CharacterBody2D

#Signals

signal player_death

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

var current_gravity
var current_speed
var current_horizontal_acceleration

var characters_direction

#Methods

func _physics_process(delta):
	characters_direction = Input.get_axis("move_left", "move_right")
	_handle_character_movement(delta)
	_handle_character_animation()


func _handle_character_movement(delta):
	_handle_vertical_movement(delta)
	_handle_horizontal_movement()
	
	move_and_slide()


func _handle_character_animation():
	if characters_direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif characters_direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	if characters_direction:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if not is_on_floor():
		$AnimatedSprite2D.play('jump')


func _handle_vertical_movement(delta):
	_handle_jump()
	_apply_gravity_to_character(delta)


func _handle_horizontal_movement():
	if characters_direction:
		velocity.x += characters_direction * current_horizontal_acceleration
		velocity.x = clampf(velocity.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, current_horizontal_acceleration)


#The character's jump is handled in 3 steps, to allow for certain features that improve game feel.
#These features are 1. jump buffering, which uses a timer to buffer the jump. This allows the player to press
#the jump button just before the character hits the ground. 2. Coyote timing, which allows the player to jump
#just after having left the ground. 3. variable jump heights, which can be varied by releasing the jump button
#before reaching the maximimum height of the jump
func _handle_jump():
	if is_on_floor():
		_reset_coyote_time()
	
	if Input.is_action_just_pressed("jump"):
		_begin_jump_buffer_period()
	
	if within_jump_time and within_coyote_time:
		_begin_jump()
	
	if Input.is_action_just_released("jump"):
		_cancel_jump()


func _apply_gravity_to_character(delta):
	if not is_on_floor():
		current_horizontal_acceleration = AIR_ACCELERATION
		
		if velocity.y >= 0:
			current_gravity = FALL_GRAVITY
		velocity.y += current_gravity * delta
		velocity.y = clampf(velocity.y, -300, 500);
	else:
		current_horizontal_acceleration = GROUND_ACCELERATION


func _reset_coyote_time():
	$CoyoteTimer.start()
	within_coyote_time = true

func _begin_jump_buffer_period():
	$JumpTimer.start()
	within_jump_time = true


func _begin_jump():
	within_coyote_time = false
	within_jump_time = false
	current_gravity = JUMP_GRAVITY
	velocity.y = JUMP_VELOCITY
	current_horizontal_acceleration = AIR_ACCELERATION


func _cancel_jump():
	current_gravity = FALL_GRAVITY
	if velocity.y < 0:
		velocity.y /= 4


func _on_jump_timer_timeout():
	within_jump_time = false


func _on_coyote_timer_timeout():
	within_coyote_time = false
