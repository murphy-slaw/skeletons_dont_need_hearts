extends "res://Character.gd"

func set_flip_sprite(active=true):
	$Sprite.flip_h = active
	if $Sprite.flip_h:
		$Sprite.offset = Vector2(2,0)
		$facing_ray.global_rotation_degrees = 180
	else:
		$Sprite.offset = Vector2(0,0)
		$facing_ray.global_rotation_degrees = 0

func can_climb():
	return facing_ray.is_colliding()

func get_normalized_motion():
	return (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
