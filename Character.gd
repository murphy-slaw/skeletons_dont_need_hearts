extends KinematicBody2D

export var walk_accel = 8
export var friction = 0.07
export var gravity = 9.8
export var jump_power = -25
var jump_speed = gravity * jump_power
export var bounce = 0
export var nudge_factor = 0.15

var FOV = 45
var sight_radius = 150


var my_motion = Vector2()

var flip_sprite = false setget set_flip_sprite, get_flip_sprite

func get_flip_sprite():
    return $Sprite.flip_h

func get_circle_arc_poly(center, radius, angle_from, angle_to):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)

    for i in range(nb_points+1):
        var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    return points_arc

func _ready():
    var circle_sector = get_circle_arc_poly(Vector2(), sight_radius, FOV/2, -FOV/2)
    $VisionArea/CollisionPolygon2D.polygon = circle_sector
    $VisionArea/CollisionPolygon2D.rotation_degrees = 90

onready var facing_ray = get_node("facing_ray")

func set_flip_sprite(active=true):
    if $Sprite.flip_h == active:
        return
    else:
        $Sprite.flip_h = active
        $facing_ray.global_rotation_degrees += 180
        $VisionArea/CollisionPolygon2D.rotation_degrees += 180
        if $Sprite.flip_h:
            $Sprite.offset = Vector2(2,0)
        else:
            $Sprite.offset = Vector2(0,0)


func is_landed():
    return is_on_floor()
#return is_on_floor() or ground_ray.is_colliding()

func can_climb():
    return false

func move(delta, the_move):

    # always add gravity. it's good and good for you!
    my_motion.y += gravity

    # reduce the actual horizontal movement by
    # our current linear velocity * frictional constant
    if is_on_floor():
        my_motion.x -= my_motion.x * friction

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
    my_motion = move_and_slide(my_motion + floor_vec, Vector2(0,-1),5,4,deg2rad(75))

    # And now we REMOVE the floor velocity from our remaining
    # movement vector, because otherwise we'll gradually
    # accelerate instead of just keeping pace with the thing
    # we're standing on!
    my_motion -= floor_vec

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

