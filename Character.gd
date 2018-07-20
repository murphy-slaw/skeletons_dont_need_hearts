extends KinematicBody2D

export var walk_accel = 7
export var friction = 0.03
export var gravity = 9.8
export var jump_power = -13
var jump_speed = gravity * jump_power
export var bounce = .99
export var nudge_factor = 0.15

var my_motion = Vector2()

var flip_sprite = false setget set_flip_sprite, get_flip_sprite

func get_flip_sprite():
	return $Sprite.flip_h

onready var ground_ray = get_node("ground_ray")
onready var facing_ray = get_node("facing_ray")

func set_flip_sprite(active=true):
	$Sprite.flip_h = active
	if $Sprite.flip_h:
		$Sprite.offset = Vector2(2,0)
		$facing_ray.global_rotation_degrees = 180
	else:
		$Sprite.offset = Vector2(0,0)
		$facing_ray.global_rotation_degrees = 0


func is_landed():
	return is_on_floor() or ground_ray.is_colliding()

func can_climb():
	return false

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
