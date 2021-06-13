tool
extends Node

class_name GameController

export (String, FILE, "*.json") var _scenario
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var map_instance: Node2D
var tile_map: TileMap
var towers: Dictionary = {}
onready var tower_parrent = $Towers
onready var ui_controller = $UI
onready var round_controller = $RoundController
onready var music_player: AudioStreamPlayer = $MusicPlayer

var modifiers = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.editor_hint:
		ui_controller.game_controller = self
		ui_controller.start()
		round_controller.ui_controller = ui_controller
		round_controller.game_controller = self
		set_scenario(_scenario)
		music_player.play()


func play_music(music: AudioStream):
	music_player.stream = music
	music_player.play()


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

	tile_map = map_instance.get_node("TileMap")
	var map_size = tile_map.to_global(tile_map.map_to_world(tile_map.get_used_rect().size))
	var vp_size = get_viewport().size
	map_instance.position = (vp_size - map_size) / 2

	if not Engine.editor_hint:
		round_controller.rounds = rounds
		round_controller.NewRound()
		round_controller.paths = get_tree().get_nodes_in_group("path")
		if result.has("music"):
			var m: AudioStreamMP3
			if result.music is String:
				m = Music.get_music_by_name(result.music)
			else:
				m = Music.get_music_by_id(result.music)
			music_player.stream = m


func add_tower(tower: Node):
	tower.game_controller = self
	tower.tile_map = tile_map
	tower_parrent.add_child(tower)


func set_tower(pos: Vector2, tower: Node):
	towers[pos] = tower


func get_tower(pos: Vector2) -> Node:
	if towers.has(pos):
		return towers[pos]
	return null

func _process(delta: float) -> void:
	if Engine.editor_hint:
		set_scenario(_scenario)
