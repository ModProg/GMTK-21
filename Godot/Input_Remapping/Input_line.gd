extends HBoxContainer
signal button_pressed

func initialize(action,key_value,is_costumizable):
	$Action.text=action.capitalize()
	$Keys.text=OS.get_scancode_string(key_value)
	$Change.disabled=not is_costumizable

func update_key(key_value):
	$Keys.text=OS.get_scancode_string(key_value)



func _on_Change_pressed():
	emit_signal("button_pressed")
