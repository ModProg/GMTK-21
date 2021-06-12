extends Control
export var TowerNodepath: NodePath
const Tower_scene = preload("res://Scenes/Tower.tscn")

onready var tower = get_node(TowerNodepath)


func _ready():
	for i in get_tree().get_nodes_in_group("Tower_button"):
		i.connect("pressed", self, "on_button_pressed", [i.name])


func on_button_pressed(button):
	var Tower_instance = Tower_scene.instance()
	Tower_instance.position = get_global_mouse_position()
	var element = Tower_instance.element
	match button:
		"Water":
			element = Tower_instance.Element.Water
		"Fire":
			element = Tower_instance.Element.Fire
		"Air":
			element = Tower_instance.Element.Air
		"Earth":
			element = Tower_instance.Element.Earth
	Tower_instance.element = element
	Tower_instance.texture = Tower_instance.textures[element]
	tower.add_child(Tower_instance)
