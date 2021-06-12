extends Node2D

# Round settings
onready var roundText = get_parent().get_parent().get_node("UIContainer").get_node("Round Text")
onready var healthText = get_parent().get_parent().get_node("UIContainer").get_node("Health Text")
onready var enemyScene = preload("res://Scenes/Enemy.tscn")
const maxRound = 10
const roundTime = 10
const spawnTime = 0.75
const health = 100
const enemies = 5

var currentRound = 0
var cur_enemies = 0
var cur_roundTime = 0
var cur_spawnTime = 0
var cur_health = 100

var end = false

func _ready():
	cur_roundTime = roundTime
	roundText.text = 'Round: ' + str(currentRound) + ' / ' + str(maxRound)
	
	cur_spawnTime = spawnTime

func _process(delta):
	if end:
		return
	# Updating timers
	cur_roundTime -= delta
	cur_spawnTime -= delta
	if cur_roundTime < 0:
		NewRound()
	elif cur_spawnTime < 0 and cur_roundTime != 0 and cur_enemies != 0:
		SpawnEnemy()

func SpawnEnemy():
	cur_spawnTime = spawnTime
	cur_enemies -= 1
	
	var enemy = enemyScene.instance()
	
	enemy.element = int(floor(rand_range(0, 3)))
	
	add_child(enemy)

func NewRound():
	if currentRound == maxRound:
		end = true
		return
	
	currentRound += 1
	cur_roundTime = roundTime
	cur_enemies = enemies
	cur_spawnTime = spawnTime
	roundText.text = 'Round: ' + str(currentRound) + ' / ' + str(maxRound)
	
func Damage(dmg):
	cur_health -= dmg
	if cur_health == 0:
		get_tree().reload_current_scene()
	healthText.text = '\nHealth: ' + str(cur_health) + ' / ' + str(health)
