extends "res://Character.gd"

var hearts = 3

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))

func hit():
    take_heart()
    
func give_heart():
    hearts += 1
    
func take_heart():
    hearts -= 1