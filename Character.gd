extends KinematicBody2D

export var walk_accel = 8
export var friction = 1
export var max_speed = 100
export var gravity = 9.8
export var jump_power = -25
var jump_speed = gravity * jump_power
export var bounce = 0
export var nudge_factor = 0.15

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

    if not is_on_floor():
        velocity.y += gravity
        
    # reduce the actual horizontal movement by
    # our current linear velocity * frictional constant
    if acceleration.x == 0:
        acceleration.x -= friction * velocity.x

    $Label.text = str(velocity)
    # add the requested motion to our vector
    velocity += acceleration

    # bounce is how perfectly we rebound. Without these
    # we stop dead when hiting walls or ceilings.
    if is_on_ceiling():
        velocity.y *= bounce
    if is_on_wall():
        velocity.x *= -bounce
    velocity.x = clamp(velocity.x,-max_speed,max_speed)

    # This is dark magic. We get the velocity of the floor
    # (which will be non-zero if we're standing on a moving
    # object. Then we move and slide with our linear
    # velocity plus the floor velocity.
    var floor_vec = get_floor_velocity()
    velocity += floor_vec
    velocity = move_and_slide(velocity, Vector2(0,-1))

    # And now we REMOVE the floor velocity from our remaining
    # movement vector, because otherwise we'll gradually
    # accelerate instead of just keeping pace with the thing
    # we're standing on!
    velocity -= floor_vec
    
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

