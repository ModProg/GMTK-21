extends Node

# Round settings
#onready var roundText = $"../../UIContainer/Round Text"
#onready var healthText = $"../../UIContainer/Health Text"
#onready var paths = get_tree().get_nodes_in_group("path")
onready var spawnTimer = $SpawnTimer
onready var roundTimer = $RoundTimer

#const enemyScene = preload("res://Scenes/Enemy.tscn")
const health = 100

var paths: Array
var rounds: Array
var index = -1
var cur_round: Round
var cur_health = health
var round_start_health: float
var end = false

var ui_controller: UIController
var game_controller: GameController


func SpawnEnemy():
	var e = cur_round.get_enemy()
	if e.empty():
		return spawnTimer.stop()
	var enemy = Enemies.random_enemy().instance()
	enemy.round_controller = self
	paths[rand_range(0, paths.size())].add_child(enemy)


func NewRound():
	index += 1
	if index == rounds.size():
		get_tree().quit(0)
		return

	cur_round = rounds[index]
	round_start_health = cur_health

	roundTimer.start(cur_round.round_time)
	spawnTimer.start(cur_round.initial_spawn_time)
	spawnTimer.wait_time = cur_round.spawn_time
	ui_controller.current_round = index + 1
	ui_controller.total_rounds = rounds.size()
	ui_controller.max_health = health
	ui_controller.health = cur_health
	ui_controller.message = cur_round.help_text
	if cur_round.music:
		game_controller.play_music(cur_round.music)
	if cur_round.has_cards():
		ui_controller.set_cards(cur_round.get_cards())
	
	game_controller.modifiers = {}
	for m in cur_round.modifiers:
		game_controller.modifiers[m]=true
		if m == "clear":
			for t in game_controller.towers.values():
				t.queue_free()
			game_controller.towers.clear()


func Damage(dmg):
	cur_health -= dmg
	if cur_health == 0:
		if cur_round.retry:
			cur_round.reset()
			cur_health = round_start_health
			index -= 1
			get_tree().call_group("enemy_parent", "queue_free")
			return NewRound()
		get_tree().reload_current_scene()
	ui_controller.health = cur_health
