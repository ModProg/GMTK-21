extends Panel

signal key_changed(key)

func _ready():
	set_process_input(false)
	

func _input(event):
	if not event.is_pressed():
		return 
	emit_signal("key_changed",event.scancode)
	close()

func open():
	show()
	set_process_input(true)

func close():
	hide()
	set_process_input(false)
