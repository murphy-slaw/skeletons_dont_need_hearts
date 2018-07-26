extends "res://Character.gd"

var hearts = 3

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))


func hit(body):
    if not is_invuln:
        take_heart()
    if body.get("facing_normal"):
            move(0,body.facing_normal * -1500)
    
func give_heart():
    hearts += 1
    
func take_heart():
    hearts -= 1