extends "res://Character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    friction = 0.03
    gravity = -0.05

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
    walk(delta,Vector2(1,0))

func _on_PoofTimer_timeout():
    queue_free()
    
func hit():
    queue_free()
