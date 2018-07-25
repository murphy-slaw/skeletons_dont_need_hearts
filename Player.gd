extends "res://Character.gd"

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))

func process_collisions()
    var count = get_slide_count()
    for i in range(count):
        var collision = get_slide_collision(i)
        $Label.text = str(collision.collider)
        if collision.collider.has_method("hit")
                collision.collider("hit")
