extends Node

enum Element { Water, Air, Earth, Fire }


class Round:
	var enemy_count: int
	var enemy_distribution: Dictionary
	var enemies: Array
	var round_time: float
	var spawn_time: float


# Round settings
onready var roundText = $"../../UIContainer/Round Text"
onready var healthText = $"../../UIContainer/Health Text"
onready var paths = get_tree().get_nodes_in_group("path")
onready var spawnTimer = $SpawnTimer
onready var roundTimer = $RoundTimer

const enemyScene = preload("res://Scenes/Enemy.tscn")
const health = 100

var rounds: Array
var cur_round  #: Round
var cur_health = health
var end = false


func SpawnEnemy():
	var e
	if cur_round.enemies:
		if cur_round.enemies.size() <= 0:
			return spawnTimer.stop()
		e = cur_round.enemies.pop_front()
	elif cur_round.enemy_distribution:
		var keys = cur_round.enemy_distribution.keys()
		if keys.size() == 0:
			return spawnTimer.stop()
		e = keys[rand_range(0, keys.size())]
		if cur_round.enemy_distribution[e] == 0:
			cur_round.enemy_distribution.erase(e)
			return SpawnEnemy()
		cur_round.enemy_distribution[e] -= 1
	else:
		if cur_round.enemy_count <= 0:
			return spawnTimer.stop()
		cur_round.enemy_count -= 1
		e = Element.values()[rand_range(0, Element.keys().size())]

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
	roundText.text = 'Rounds remaining: ' + str(rounds.size())


func Damage(dmg):
	cur_health -= dmg
	if cur_health == 0:
		get_tree().reload_current_scene()
	healthText.text = '\nHealth: ' + str(cur_health) + ' / ' + str(health)
