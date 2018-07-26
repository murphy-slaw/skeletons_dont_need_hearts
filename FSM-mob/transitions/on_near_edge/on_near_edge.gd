tool
extends "res://addons/moe.ero-one.fsm/content/FSMTransition.gd";

var edge_count = 0

func get_fsm(): return fsm; #access to owner FSM, defined in parent class
func get_logic_root(): return logic_root; #access to logic root of FSM (usually fsm.get_parent())

func transition_init(args = []): 
    #you can optionally implement this to initialize transition on it's creation time 
    pass

func prepare(new_state, args = []): 
    #you can optionally implement this to reset transition when related state has been activated
    pass

func transition_condition(delta, args = []): 
    # Return true/false
    if edge_count > 5:
        return false
    if logic_root.is_near_edge() and edge_count < 5:
        edge_count +=1 
        return true
    elif edge_count >= 5:
        edge_count = 0
        
    else:
        return false
