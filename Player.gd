extends KinematicBody2D

var acceleration = Vector2()

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
	return facing_ray.is_colliding()

func walk(delta, normal_vec):
	var walk_vec = Vector2(walk_accel,0)
	move(delta, normal_vec * walk_vec)

func nudge(delta, normal_vec):
	var nudge_vec = Vector2(walk_accel * nudge_factor,0)
	move (delta, normal_vec * nudge_vec)

func move(delta, the_move):

	# always add gravity. it's good and good for you!
	my_motion.y += gravity

	# reduce the actual horizontal movement by
	# our current linear velocity * frictional constant
	if is_on_floor():
		the_move.x -= my_motion.x * friction

	# add the requested motion to our vector
	my_motion += the_move

	# bounce is how perfectly we rebound. Without these
	# we stop dead when hiting walls or ceilings.
	if is_on_ceiling():
		my_motion.y *= bounce
	if is_on_wall():
		my_motion.x *= -bounce

	# This is dark magic. We get the velocity of the floor
	# (which will be non-zero if we're standing on a moving
	# object. Then we move and slide with our linear
	# velocity plus the floor velocity.
	var floor_vec = get_floor_velocity()
	my_motion = move_and_slide(my_motion + floor_vec, Vector2(0,-1),1,1,0.872665)

	# And now we REMOVE the floor velocity from our remaining
	# movement vector, because otherwise we'll gradually
	# accelerate instead of just keeping pace with the thing
	# we're standing on!
	my_motion -= floor_vec

func raw_move(vec=Vector2()):
	move_and_slide(my_motion+vec)

func show_walk():
	$AnimationPlayer.play("Walk")
	
func show_idle():
	$AnimationPlayer.play("Idle")

func show_falling():
	$AnimationPlayer.play("Jump")

func show_jumping():
	$AnimationPlayer.play("Jump")
	
func get_normalized_motion():
	return (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
