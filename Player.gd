extends "res://Character.gd"

func can_climb():
	return facing_ray.is_colliding()

func get_normalized_motion():
	return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))