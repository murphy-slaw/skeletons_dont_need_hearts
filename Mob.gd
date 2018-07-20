extends "res://Character.gd"

onready var target = get_parent().get_node("Player")

func _ready():
	gravity = 500
	accel = 500
	max_speed = 200
	jump_speed = -200
	if target == null:
		target = self

func get_acc_x():
	var direction = (target.global_position - global_position).normalized()
	acc.x = direction.x
	acc.y += direction.y

	
func get_motion_y():
	if is_on_floor():
		motion.y = jump_speed

func _on_Lifespan_timeout():
	queue_free()
