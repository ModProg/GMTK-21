extends Node

# Round settings
onready var roundText = $"../../UIContainer/Round Text"
onready var healthText = $"../../UIContainer/Health Text"
onready var paths = get_tree().get_nodes_in_group("path")
onready var spawnTimer = $SpawnTimer
onready var roundTimer = $RoundTimer

const enemyScene = preload("res://Scenes/Enemy.tscn")
const maxRound = 10
const roundTime = 10
const spawnTime = 0.75
const health = 100
const enemies = 5

var currentRound = -1
var cur_enemies = 0
var cur_health = 100

var end = false

func _ready():
	NewRound()

func SpawnEnemy():
	print("hi")
	if enemies == 0:
		spawnTimer.stop()
		return
	cur_enemies -= 1
	var enemy = enemyScene.instance()
	enemy.element = int(floor(rand_range(0,4)))
	enemy.round_controller = self
	print(paths)
	paths[rand_range(0,paths.size())].add_child(enemy)

func NewRound():
	if currentRound == maxRound:
		end = true
		return
	
	currentRound += 1
	roundTimer.start(roundTime)
	spawnTimer.start(spawnTime)
	cur_enemies = enemies
	roundText.text = 'Round: ' + str(currentRound) + ' / ' + str(maxRound)
	
func Damage(dmg):
	cur_health -= dmg
	if cur_health == 0:
		get_tree().reload_current_scene()
	healthText.text = '\nHealth: ' + str(cur_health) + ' / ' + str(health)
