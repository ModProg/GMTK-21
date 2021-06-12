tool
extends Node

enum JSONElement { water, air, earth, fire }

export (String, FILE, "*.json") var _scenario
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var instance


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_scenario(_scenario)


func set_scenario(scenario):
	if instance:
		instance.queue_free()
	var scene: PackedScene
	var file = File.new()
	file.open(scenario, file.READ)
	var text = file.get_as_text()
	var json = JSON.parse(text)
	var result = json.result
	for r in result["rounds"]:
		if r.has("enemy_distribution"):
			var ed = r.enemy_distribution
			r.enemy_distribution = {}
			for e in JSONElement.keys():
				if ed.has(e):
					r.enemy_distribution[JSONElement[e]] = ed[e]
				else:
					r.enemy_distribution[JSONElement[e]] = 0
		else:
			r.enemy_distribution = null
		if r.has("enemies"):
			var es = r.enemies
			r.enemies = []
			for e in es:
				r.enemies.append(JSONElement[e])
		else:
			r.enemies = null
		if not r.has("enemy_count"):
			r.enemy_count = 0

	instance = load("res://Scenes/Maps/" + result.map + ".tscn").instance()
	$Node2D.add_child(instance)
	$Node2D.move_child(instance, 0)

	if not Engine.editor_hint:
		$Node2D/RoundController.rounds = result.rounds
		$Node2D/RoundController.NewRound()
		$Node2D/RoundController.paths = get_tree().get_nodes_in_group("path")


func _process(delta: float) -> void:
	if Engine.editor_hint:
		set_scenario(_scenario)
