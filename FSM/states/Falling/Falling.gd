extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 

func state_init(args = null):
	.state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
	.enter(from_state, from_transition, args)
	logic_root
	logic_root.show_falling()

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
	.update(delta, args)
	var motion = Vector2()
	motion.x = logic_root.get_normalized_motion()
	logic_root.nudge(delta, motion)

#when exiting state
func exit(to_state=null):
	if to_state == "Climbing":
		logic_root.my_motion.y = 0
	.exit(to_state)
