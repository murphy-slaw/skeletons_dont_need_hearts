extends "res://Character.gd"

var hearts = 3

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))

func hit():
    take_heart()
    move(0,facing_normal * -1500)
    
func give_heart():
    hearts += 1
    
func take_heart():
    hearts -= 1