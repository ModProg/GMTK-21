extends Node

signal changed_profile(new_profile,is_coustmizable)

var current_profile_id:int=0
var profiles:Dictionary={
	0:"default_profile",
	1:"arrow_profile",
	2:"profile_coustum"
}
var default_profile:Dictionary={
	"ui_up":KEY_W,
	"ui_down":KEY_S,
	"ui_left":KEY_A,
	"ui_right":KEY_D
}
var arrow_profile:Dictionary={
	"ui_up":KEY_UP,
	"ui_down":KEY_DOWN,
	"ui_left":KEY_LEFT,
	"ui_right":KEY_RIGHT
}
var profile_coustum:Dictionary=default_profile

func change_profile(id:int)->Dictionary:
	current_profile_id=id
	print(id)
	var profile=get(profiles[id])
	var costumizable:bool=true if id==2  else false
	
	for action_keys in profile.keys():
		change_action_key(action_keys,profile[action_keys])
	emit_signal("changed_profile",profile,costumizable)
	return profile

func change_action_key(action_key:String,keycode:int)->void:
	erase_action(action_key)

	var new_event = InputEventKey.new()
	new_event.set_scancode(keycode)
	InputMap.action_add_event(action_key,new_event)
	get_current_profile()[action_key]=keycode

func erase_action(action_key:String)->void:
	var events:Array=InputMap.get_action_list(action_key)

	for event in events:
		InputMap.action_erase_event(action_key, event)

func get_current_profile()->Dictionary:
	return get(profiles[current_profile_id])

func on_profile_menu_changed(ID:int)->void:
	change_profile(ID)
