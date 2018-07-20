extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal boing

export (Vector2) var boing_vec

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("boing",get_parent(),"_on_Boinger_boing")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Boinger_body_entered(body):
	emit_signal("boing",boing_vec,body)