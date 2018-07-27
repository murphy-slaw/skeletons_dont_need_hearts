extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class

var vel 

func state_init(args = null):
    .state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)
    vel = logic_root.jump_speed
    logic_root.audio_player.stream = load("res://audio/sounds/jump.wav")
    logic_root.audio_player.play()


#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)
    var motion = Vector2(0,vel)
    logic_root.move(delta,motion)

#when exiting state
func exit(to_state=null):
    .exit(to_state)
