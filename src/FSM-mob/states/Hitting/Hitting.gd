extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 


func state_init(args = null):
    .state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)
    if not logic_root.can_see_target:
        logic_root.is_dying = true
    else:
        logic_root.is_hit = false
        logic_root.target.hit(self)
        yield(get_tree().create_timer(2), "timeout");

#when exiting state
func exit(to_state=null):
    .exit(to_state)
