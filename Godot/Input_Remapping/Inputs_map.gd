extends Node

signal changed_profile(new_profile,is_coustmizable)

var current_profile_id=0
var profiles={
	0:"default_profile",
	1:"arrow_profile",
	2:"profile_costum"
}
var default_profile={
	"Move_Up":KEY_W,
	"Move_down":KEY_S,
	"Move_left":KEY_A,
	"Move_right":KEY_D
}
var arrow_profile={
	"Move_Up":KEY_UP,
	"Move_down":KEY_DOWN,
	"Move_left":KEY_LEFT,
	"Move_right":KEY_RIGHT
}
var profile_coustum=default_profile

func change_profile(id):
	current_profile_id=id
	var profile=get(profiles[id])
	var costumizable=true if id==2  else false
	
	for action_keys in profile.keys():
		change_action_key(action_keys,profile[action_keys])
	emit_signal("changed_profile",profile,costumizable)

func change_action_key(action_key,keycode):
	erase_action(action_key)
	
	var new_event=InputEventKey.new()
	new_event.set_scancode(keycode)
	InputMap.add_action_event(action_key,new_event)
	get_current_profile()[action_key]=keycode
func erase_action(action_key):
	var events=InputMap.get_action_list(action_key)
	for event in events:
		InputMap.action_erase_event(action_key,event)

func get_current_profile():
	return get(profiles[current_profile_id])

func on_profile_menu_changed(ID):
	change_profile(ID)
