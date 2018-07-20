extends KinematicBody2D


var accel = 500
var max_speed = 225
var friction = -250
var gravity = 500
var jump_speed = -500


var bounce = .25

var acc = Vector2()
var motion = Vector2()
var last_collider

onready var ground_ray = get_node("ground_ray")

func _physics_process(delta):
	var cur_accel = accel

	if not is_on_floor():
		acc.y = gravity

	if not ((ground_ray and ground_ray.is_colliding()) or is_on_floor()):
		cur_accel *= .25

	get_acc_x()
	acc.x *= cur_accel

	if is_on_floor():
		acc.x += motion.x * friction * delta
		motion.y = 0 # don't accumulate gravitational acceleration


	get_motion_y()

	motion += acc * delta
	if is_on_ceiling():
		motion.y *= -bounce
	if is_on_wall():
		motion.x *= -bounce


	motion.x = clamp(motion.x, -max_speed, max_speed)

	motion += get_floor_velocity() * delta

	move_and_slide(motion, Vector2(0,-1),4,4,0.872665)

	update_animations()

func update_animations():
	pass

func get_motion_y():
	return Vector2()

func get_acc_x():
	return Vector2()
