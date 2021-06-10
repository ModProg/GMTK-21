extends Node

signal changed_profile(new_profile:Dictionary),(is_coustmizable:bool)

var current_profile_id:int=0
var profiles:Dictionary={
	0:"default_profile",
	1:"arrow_profile",
	2:"profile_costum"
}
var default_profile:Dictionary={
	"Move_Up":KEY_W,
	"Move_down":KEY_S,
	"Move_left":KEY_A,
	"Move_right":KEY_D
}
var arrow_profile:Dictionary={
	"Move_Up":KEY_UP,
	"Move_down":KEY_DOWN,
	"Move_left":KEY_LEFT,
	"Move_right":KEY_RIGHT
}
var profile_coustum:Dictionary=default_profile

func change_profile(id:int)->Dictionary:
	current_profile_id=id
	var profile:Dictionary=get(profiles[id])
	var costumizable:bool=true if id==2  else false
	
	for action_keys in profile.keys():
		change_action_key(action_keys,profile[action_keys])
	emit_signal("changed_profile",profile,costumizable)
	return profile
func change_action_key(action_key:String,keycode:int)->void:
	erase_action(action_key)

	var new_event = InputEventKey.new()
	new_event.set_scancode(keycode)
	InputMap.add_action_event(action_key,new_event)
	get_current_profile()[action_key]=keycode

func erase_action(action_key:String)->void:
	var events:Array=InputMap.get_action_list(action_key)
	for event in events:
		InputMap.action_erase_event(action_key, event)

func get_current_profile()->Dictionary:
	return get(profiles[current_profile_id])

func on_profile_menu_changed(ID:int)->void:
	change_profile(ID)
