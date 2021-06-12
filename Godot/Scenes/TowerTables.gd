extends Control
export var TowerNodepath:NodePath
const Tower_scene=preload("res://Scenes/Tower.tscn")

onready var tower=get_node(TowerNodepath)


func _ready():
	for i in get_tree().get_nodes_in_group("Tower_button"):
		i.connect("pressed",self,"on_button_pressed",[i.name])

func on_button_pressed(button):
	var Tower_instance=Tower_scene.instance()
	Tower_instance.position=get_global_mouse_position()
	Tower_instance.element=button
	Tower_instance.texture=Tower_instance.textures[Tower_instance.element]
	tower.add_child(Tower_instance)

