extends "res://Character.gd"

signal die

onready var target = get_parent().get_node("Player")

func _ready():
	walk_accel = 1
	if target == null:
		target = self

#func move(delta,the_movement):
#	.move(delta,the_movement)
#	var slide_count = get_slide_count()
#	var sliders = []
#	var i
#	for i in range(slide_count):
#		var slide = get_slide_collision(i)
#		sliders.append(slide)
#	return
	
	
	

#func get_acc_x():
#	var direction = (target.global_position - global_position).normalized()
#	acc.x = direction.x
#	acc.y += direction.y
#

#func get_motion_y():
#	if (randi() % 30 == 1):
#        if is_on_floor():
#            motion.y = jump_speed

onready var edge_ray = get_node("edge_ray")

func _on_Lifespan_timeout():
	emit_signal("die")
	queue_free()

func get_vision_normal():
    return ($facing_ray.position * $facing_ray.cast_to).normalized()

func get_normalized_motion():
	return Vector2(0,0)
	
func check_ahead():
	var test_motion = Vector2(1,0)
	if get_flip_sprite():
		test_motion = Vector2(-1,0)
	test_motion *= 5
	return test_move(transform, test_motion)
	
func check_for_edge():
	return edge_ray.is_colliding()
	
func set_flip_sprite(active):
	.set_flip_sprite(active)
	edge_ray.position *= Vector2(-1,1)
