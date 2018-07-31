extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 


var prev_state

func state_init(args = null):
    .state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)
    prev_state = from_state
    logic_root.take_heart()
    if logic_root.hearts <= 0:
        logic_root.is_dying = true
    logic_root.become_invuln()
    logic_root.audio_player.stream = load("res://audio/sounds/oof.wav")
    logic_root.audio_player.play()
    var knockback = logic_root.attack_dir * 2000
    knockback.y = -100
#    logic_root.velocity += knockback
    logic_root.is_hit = false
#    yield(get_tree().create_timer(.5), "timeout");
        
#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)
    logic_root.move(delta, Vector2())
    

#when exiting state
func exit(to_state=null):
    .exit(prev_state)
