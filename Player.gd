extends "res://Character.gd"

func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))


func _on_Player_hit():
    pass # replace with function body
