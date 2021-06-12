tool
extends Node

class_name GameController


export (String, FILE, "*.json") var _scenario
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var map_instance: Node2D
onready var towers = $Towers
onready var ui_controller: UIController = $UI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_controller.game_controller = self
	ui_controller.start()
	$RoundController.ui_controller = ui_controller
	set_scenario(_scenario)


func set_scenario(scenario):
	if map_instance:
		map_instance.queue_free()
	var file = File.new()
	file.open(scenario, file.READ)
	var text = file.get_as_text()
	var json = JSON.parse(text)
	var result = json.result
	var rounds = []
	for r in result["rounds"]:
		rounds.append(Round.new().from_dict(r))
		
	map_instance = load("res://Scenes/Maps/" + result.map + ".tscn").instance()
	add_child(map_instance)
	move_child(map_instance, 0)
	
	var tile_map: TileMap = map_instance.get_node("TileMap")
	var map_size = tile_map.to_global(tile_map.map_to_world(tile_map.get_used_rect().size))
	var vp_size = get_viewport().size
	map_instance.position = (vp_size - map_size) / 2

	if not Engine.editor_hint:
		$RoundController.rounds = rounds
		$RoundController.NewRound()
		$RoundController.paths = get_tree().get_nodes_in_group("path")


func add_tower(tower: Node):
	tower.game_controller = self
	towers.add_child(tower)


func _process(delta: float) -> void:
	if Engine.editor_hint:
		set_scenario(_scenario)
