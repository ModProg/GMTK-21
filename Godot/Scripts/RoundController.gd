extends Node

enum Element { Water, Air, Earth, Fire }


# Round settings
#onready var roundText = $"../../UIContainer/Round Text"
#onready var healthText = $"../../UIContainer/Health Text"
#onready var paths = get_tree().get_nodes_in_group("path")
onready var spawnTimer = $SpawnTimer
onready var roundTimer = $RoundTimer

const enemyScene = preload("res://Scenes/Enemy.tscn")
const health = 100

var paths: Array
var rounds: Array
var cur_round: Round
var cur_health = health
var end = false

var ui_controller: UIController


func SpawnEnemy():
	var e = cur_round.get_enemy()
	if e == -1:
		return spawnTimer.stop()
	var enemy = enemyScene.instance()
	enemy.element = e
	enemy.round_controller = self
	paths[rand_range(0, paths.size())].add_child(enemy)


func NewRound():
	if rounds.size() == 0:
		end = true
		return

	cur_round = rounds.pop_front()
	roundTimer.start(cur_round.round_time)
	spawnTimer.start(cur_round.spawn_time)
	ui_controller.rounds_remaining = rounds.size()
	ui_controller.max_health = health


func Damage(dmg):
	cur_health -= dmg
	if cur_health == 0:
		get_tree().reload_current_scene()
	ui_controller.health = cur_health
