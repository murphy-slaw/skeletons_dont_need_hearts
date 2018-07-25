extends KinematicBody2D

var walk_accel = 8
var friction = 0.05
var max_speed = 250
var gravity = 9.8
var jump_power = -25
var jump_speed = gravity * jump_power
var bounce = 0
var nudge_factor = 0.15

var velocity = Vector2()

var flip_sprite = false setget set_flip_sprite, get_flip_sprite

func get_flip_sprite():
    return $Sprite.flip_h

onready var facing_ray = get_node("facing_ray")

func set_flip_sprite(active=true):
    if $Sprite.flip_h == active:
        return
    else:
        $Sprite.flip_h = active
        $facing_ray.global_rotation_degrees += 180
        if $Sprite.flip_h:
            $Sprite.offset = Vector2(2,0)
        else:
            $Sprite.offset = Vector2(0,0)


func is_landed():
    return is_on_floor() or is_near_floor()


func can_climb():
    return false

func move(delta, acceleration):

    velocity.y += gravity
        
    # reduce the actual horizontal movement by
    # our current linear velocity * frictional constant
    if acceleration.x == 0\
    and get_floor_velocity() != Vector2(0,0):
        acceleration.x -= friction * velocity.x
    
#    $Label.text = str(velocity) + str(acceleration) + str(friction)
    # add the requested motion to our vector
    velocity += acceleration

    # bounce is how perfectly we rebound. Without these
    # we stop dead when hiting walls or ceilings.
    if is_on_ceiling():
        velocity.y *= bounce
    if is_on_wall():
        velocity.x *= -bounce
    velocity.x = clamp(velocity.x,-max_speed,max_speed)

    velocity = \
    move_and_slide(velocity, Vector2(0,-1))

    
    
func is_near_floor():
    var test_motion = Vector2(0,2)
    return test_move(transform,test_motion)

func walk(delta, normal_vec):
    var walk_vec = Vector2(walk_accel,0)
    move(delta, normal_vec * walk_vec)

func nudge(delta, normal_vec):
    var nudge_vec = Vector2(walk_accel * nudge_factor,0)
    move (delta, normal_vec * nudge_vec)

func show_walk():
    $AnimationPlayer.play("Walk")

func show_idle():
    $AnimationPlayer.play("Idle")

func show_falling():
    $AnimationPlayer.play("Jump")

func show_jumping():
    $AnimationPlayer.play("Jump")

func get_normalized_motion():
    pass

