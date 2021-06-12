extends Control
const Tower_scene = preload("res://Scenes/Tower.tscn")

var game_controller: GameController

var current_element

func _ready():
	for i in get_tree().get_nodes_in_group("Tower_button"):
		i.connect("mouse_entered", self, "entered", [i.name])
		i.connect("mouse_exited",self,"exited",[i.name])

func entered(button_name):
	current_element=button_name

func exited(button_name):
	current_element=null

func _gui_input(event):
	
	if current_element!=null:
		if event.is_action_pressed("Click"):
			var Tower_instance=Tower_scene.instance()
			Tower_instance.position=get_global_mouse_position()
			Tower_instance.element=current_element
			Tower_instance.texture=Tower_instance.textures[Tower_instance.element]
			game_controller.add_child(Tower_instance)
