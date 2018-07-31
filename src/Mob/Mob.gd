extends "res://Character.gd"

var Heart = load("res://Heart.tscn")

signal die
signal aggro
signal calm

var target_in_range = false
var can_see_target = false
var aggro_exhausted = true
var original_max_speed
var original_walk_accel
var is_hit = false
var is_dying = false
var edge_count = 0
var mob_seen_count = 0

export (int) var FOV = 45
export (int) var sight_radius = 150

onready var target = get_parent().get_node("Player")
onready var edge_ray = get_node("edge_ray")

func _ready():
    if target == null: target = self
    walk_accel = 5
    max_walk_speed = 50
    original_max_speed = max_walk_speed
    original_walk_accel = walk_accel
    if (randi() % 2 == 1):
        reverse_facing()

func _physics_process(delta):
    assert not (is_dying and not is_hit)
    check_in_bounds()
    check_target_visibility()

func check_target_visibility():    
    var vec_to_target = target.global_position - global_position
    var distance_to_target = vec_to_target.length()
    var target_dot = vec_to_target.normalized().dot(facing_normal)
    if distance_to_target <= sight_radius and target_dot > 0:
        var space_state = get_world_2d().direct_space_state
        var result = space_state.intersect_ray(global_position, target.global_position, [self])
        if result:
            can_see_target = (result.collider == target)
            if result.collider.is_in_group("mobs"):
                mob_seen_count +=1
                edge_count += 2
                
        
func get_state():
    return $FSM2D.current_state_ID
    
        
func check_in_bounds():
    if out_of_bounds():
        emit_signal("die")
        queue_free()
        
func is_on_screen():
    return $VisibilityNotifier2D.is_on_screen()
    
func out_of_bounds():
    return (global_position.x < 0 or\
        global_position.x > 640 or\
        global_position.y < 0)
        
func die():
    audio_player.stream = load("res://audio/sounds/die.wav")
    audio_player.play()
    var parent = get_parent().get_parent()
    emit_signal("die",self)
    visible = false
    set_collision_layer_bit(1,false)
    var heart = Heart.instance()
    heart.global_position = global_position + (facing_normal * 16)
    heart.apply_impulse(Vector2(),facing_normal * 300)
    parent.call_deferred("add_child",heart)
    heart.connect("caught",parent,"_on_heart_caught")
    yield(audio_player,"finished")
    queue_free()

func hit(body):
    is_hit = true
    

func _on_Lifespan_timeout():
    if is_on_screen():
        yield($VisibilityNotifier2D,"screen_exited")
        print("death delayed because visible")
    emit_signal("die",self)
    print("died offscreen")
    queue_free()
    
func check_ahead():
    var test_motion = 5 * facing_normal
    return test_move(transform, test_motion)
    
func is_near_edge():
    return not edge_ray.is_colliding()
    
func reverse_facing():
    edge_ray.position *= Vector2(-1,1)
    .reverse_facing()

func start_aggro():
    emit_signal("aggro")
    audio_player.stream = load("res://audio/sounds/ugh.wav")
    audio_player.play()
    max_walk_speed *= 3
    walk_accel *= 2
    aggro_exhausted = false
    modulate = Color(1,.7,.7,1)
    $AggroTimer.start()
    
func end_aggro():
    emit_signal("calm")
    $AggroTimer.stop()
    max_walk_speed = original_max_speed
    walk_accel = original_walk_accel
    aggro_exhausted = true
    modulate = Color(1,1,1,1)

func _on_AggroTimer_timeout():
    end_aggro()

func set_label(text):
    $Label.text = text

func _on_StuckTimer_timeout():
    edge_count = 0
