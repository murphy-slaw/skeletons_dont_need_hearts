extends RigidBody2D

signal caught

func _on_PoofTimer_timeout():
    queue_free()
    
func hit(body):
    emit_signal("caught")
    queue_free()
