extends "res://Character.gd"

var hearts = 3
var is_hit = false
var is_dying = false
var attack_dir = Vector2()

onready var animation_player = get_node("AnimationPlayer")

func _physics_process(delta):
    $AnimationPlayer.playback_speed = abs(velocity.x / 100) + 0.5

func _ready():
    enemy_layer = 1
    
func get_normalized_motion():
    return (int(Input.is_action_pressed("ui_right"))\
            - int(Input.is_action_pressed("ui_left")))


func hit(body):
    if not is_invuln:
        is_hit = true 
        attack_dir = body.get("facing_normal")
        if not attack_dir: attack_dir = Vector2()
    
func give_heart():
    audio_player.stream = load("res://audio/sounds/pickup_heart.wav")
    audio_player.play()
    hearts += 1
    
func take_heart():
    hearts -= 1
    
func die():
    animation_player.stop()
    animation_player.play("Dying")
    
