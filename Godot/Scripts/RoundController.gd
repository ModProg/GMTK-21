extends Node2D

# Round settings
onready var roundText = get_parent().get_parent().get_node("UIContainer").get_node("Round Text")
onready var enemyScene = preload("res://Scenes/Enemy.tscn")
var roundTime = 10
var spawnTime = 1
var enemies = 30

var currentRound = 0
var cur_enemies = 0
var cur_roundTime = 0.1
var cur_spawnTime = 0

func _ready():
	NewRound()

func _process(delta):
	# Updating timers
	cur_roundTime -= delta
	cur_spawnTime -= delta
	if cur_roundTime < 0:
		NewRound()
	elif cur_spawnTime < 0:
		SpawnEnemy()

func SpawnEnemy():
	cur_spawnTime = spawnTime
	
	var enemy = enemyScene.instance()
	add_child(enemy)

func NewRound():
	currentRound += 1
	cur_roundTime = roundTime
	cur_enemies = enemies
	cur_spawnTime = spawnTime
	roundText.text = 'Round: ' + str(currentRound) + ' / 10'
