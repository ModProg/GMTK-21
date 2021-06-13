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
onready var ui_controller = $Node2D/UI
onready var round_controller = $RoundController
onready var music_player: AudioStreamPlayer = $MusicPlayer
var reverse
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

func set_map(map: String):
	if map_instance:
		map_instance.queue_free()
	map_instance = load("res://Scenes/Maps/" + map + ".tscn").instance()
	tile_map = map_instance.get_node("TileMap")
	var map_size = tile_map.to_global(tile_map.map_to_world(tile_map.get_used_rect().size))
	var vp_size = get_viewport().size
	map_instance.position = (vp_size - map_size) / 2
	add_child(map_instance)
	move_child(map_instance, 0)
	round_controller.paths = map_instance.get_node("Paths").get_children()

func set_scenario(scenario):
	randomize()
	reverse = false
	if scenario.empty():
		round_controller.rounds = []
		reverse = true
		for i in range(1,30):
			var r = Round.new()
			r.name = "Round "+str(i)+"/"+str(30)
			r.round_time = 20
			r.spawn_time = 1
			r.card_count_add = 2
			r.map = Maps.random_map()
			r.enemy_count = sqrt(i)*4
			round_controller.rounds.append(r)
		play_music(Music.get_random_music())
		round_controller.NewRound()
		return
	var file = File.new()
	file.open(scenario, file.READ)
	var text = file.get_as_text()
	var json = JSON.parse(text)
	var result = json.result
	var rounds = []
	for r in result["rounds"]:
		rounds.append(Round.new().from_dict(r))
		
	round_controller.rounds = rounds
	round_controller.NewRound()
#	if result.has("music"):
#		var m: AudioStreamMP3
#		if result.music is String:
#			m = Music.get_music_by_name(result.music)
#		else:
#			m = Music.get_music_by_id(result.music)
#		music_player.stream = m


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
