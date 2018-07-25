extends "res://Character.gd"

var hearts = 3

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))

func process_collisions():
    var count = get_slide_count()
    for i in range(count):
        var collision = get_slide_collision(i)
        if collision.collider.has_method("hit"):
                collision.collider.hit()

func hit():
    pass
    
func give_heart():
    hearts += 1
    
func take_heart():
    hearts -= 1