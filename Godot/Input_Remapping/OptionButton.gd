extends OptionButton


func initalize(input_mapper):
	for profile_index in input_mapper.profiles:
		var profile=input_mapper.profiles[profile_index]
		add_item(profile,profile_index)
	self.connect("item_selected",input_mapper,"on_profile_menu_changed")
	pass
