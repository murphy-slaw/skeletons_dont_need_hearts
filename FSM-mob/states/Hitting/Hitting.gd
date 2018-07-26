extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 

var source_state

func state_init(args = null):
    .state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)
    source_state = from_state
    logic_root.is_hit = false
    if not logic_root.can_see_target:
        logic_root.die()
    else:
        logic_root.become_invuln()
        logic_root.target.hit(self)

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)

#when exiting state
func exit(to_state=null):
    .exit(to_state)
