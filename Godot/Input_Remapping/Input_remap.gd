extends Control



func _ready():
	$Inputs_map.connect("changed_profile",self,"rebuild")
	$Column/OptionButton.initalize($Inputs_map)
	$Inputs_map.change_profile($Column/OptionButton.selected)



func rebuild(input_profile,is_coustumizable=false):
	$Column/ScrollContainer/ActionList.clear()
	for input_action in input_profile.keys():
		var line=$Column/ScrollContainer/ActionList.add_input_line(input_action,input_profile[input_action],is_coustumizable)
		if is_coustumizable:
			line.connect("button_pressed",self,"On_change_button_pressed",[input_action,line])

func On_change_button_pressed(input_action,line):
	set_process_input(false)

	$ChangeKey.open()
	var key_scancode=yield($ChangeKey,"key_changed")
	$Inputs_map.change_action_key(input_action,key_scancode)
	line.update_key(key_scancode)

	set_process_input(true)
