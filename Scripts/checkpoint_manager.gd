extends Node

var current_checkpoint
var checkpoint_list

@onready var player = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_death.connect(handle_respawn)
	
	checkpoint_list = []
	for child in get_children():
		if child.has_signal('checkpoint_activated'):
			checkpoint_list.append(child)
			child.checkpoint_activated.connect(activate_new_checkpoint)


func activate_new_checkpoint(new_checkpoint):
	if current_checkpoint:
		current_checkpoint.deactivate()
	
	current_checkpoint = new_checkpoint
	current_checkpoint.activate()


func handle_respawn():
	print('player died, handling respawn')
	$DeathTimer.start()


func _on_death_timer_timeout():
	if current_checkpoint:
		player.position = current_checkpoint.position
		player.position.y -= 16
	else:
		get_tree().reload_current_scene()
