extends "res://character.gd"

onready var target = get_parent().get_node("Player")

func _ready():
	bounce = .9
	if target == null:
		target = self

#func get_acc_x():
#	var direction = (target.global_position - global_position).normalized()
#	acc.x = direction.x
#	acc.y += direction.y
#

#func get_motion_y():
#	if (randi() % 30 == 1):
#        if is_on_floor():
#            motion.y = jump_speed

func _on_Lifespan_timeout():
	queue_free()

func get_vision_normal():
    return ($facing_ray.position * $facing_ray.cast_to).normalized()

func get_normalized_motion():
	return Vector2(0,0)
	
func check_ahead():
	var test_motion = Vector2(1,0)
	if get_flip_sprite():
		test_motion = Vector2(-1,0)
	test_motion *= 2
	return test_move(transform, test_motion)
