extends VBoxContainer

const Input_line=preload("res://Input_Remapping/Input_line.tscn")


func clear():
	for line in get_children():
		line.free()

func add_input_line(action,key_value,is_costumizable=false):
	var line=Input_line.instance()
	line.initialize(action,key_value,is_costumizable)
	add_child(line)
	return line
