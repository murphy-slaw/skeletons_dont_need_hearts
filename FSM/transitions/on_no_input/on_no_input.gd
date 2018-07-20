tool
extends "res://addons/moe.ero-one.fsm/content/FSMTransition.gd";

func get_fsm(): return fsm; #access to owner FSM, defined in parent class
func get_logic_root(): return logic_root; #access to logic root of FSM (usually fsm.get_parent())

func transition_init(args = []): 
	#you can optionally implement this to initialize transition on it's creation time 
	pass

func prepare(new_state, args = []): 
	#you can optionally implement this to reset transition when related state has been activated
	pass

func transition_condition(delta, args = []):
	if Input.is_action_pressed("ui_select"):
		return false
	for action in ["ui_left","ui_right","ui_up"]:
		if Input.is_action_pressed(action):
			return false
#		if logic_root.can_climb(:
#			return false
	return true