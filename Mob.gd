extends "res://Character.gd"

signal die

onready var target = get_parent().get_node("Player")
onready var edge_ray = get_node("edge_ray")



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
    if target == null: target = self	

#func get_acc_x():
#	var direction = (target.global_position - global_position).normalized()
#	acc.x = direction.x
#	acc.y += direction.y
#

#func get_motion_y():
#	if (randi() % 30 == 1):
#        if is_on_floor():
#            motion.y = jump_speed

#onready var edge_ray = get_node("edge_ray")

func _on_Lifespan_timeout():
    emit_signal("die")
    queue_free()

func get_vision_normal():
    return ($facing_ray.position * $facing_ray.cast_to).normalized()

#func get_normalized_motion():
#	return Vector2(0,0)
    
func check_ahead():
    var test_motion = Vector2(1,0)
    if get_flip_sprite():
        test_motion = Vector2(-1,0)
    test_motion *= 5
    return test_move(transform, test_motion)
    
func is_near_edge():
    return not edge_ray.is_colliding()
    
func set_flip_sprite(active):
    .set_flip_sprite(active)
    $VisionArea/CollisionPolygon2D.rotation_degrees += 180
    edge_ray.position *= Vector2(-1,1)
