extends Control

class_name UIController

var message: String setget set_message
var health: int setget set_health
var _health: int
var max_health: int setget set_max_health
var _max_health: int
var total_rounds: int setget set_total_rounds
var _total_rounds: int
var current_round: int setget set_current_round
var _current_round: int
#var game_controller: GameController setget set_game_controller

onready var roundText: RichTextLabel = $"MarginContainer/Round Text"
onready var healthText: RichTextLabel = $"MarginContainer/Health Text"
onready var towerTables = $MarginContainer2/TowerTables
var game_controller


func start() -> void:
	towerTables.game_controller = game_controller


func set_message(value: String):
	pass


#func set_game_controller(value: GameController):
#	towerTables.game_controller = value


#func set_rounds_remaining(value: int):
#	roundText.text = 'Rounds remaining: ' + str(value)


func set_health(value: int):
	_health = value
	healthText.text = '\nHealth: ' + str(_health) + ' / ' + str(_max_health)


func set_max_health(value: int):
	_max_health = value
	healthText.text = '\nHealth: ' + str(_health) + ' / ' + str(_max_health)

func set_total_rounds(value: int):
	_total_rounds = value
	roundText.text = 'Round ' + str(_current_round) + "/"+str(_total_rounds)

func set_current_round(value: int):
	_current_round = value
	roundText.text = 'Round ' + str(_current_round) + "/"+str(_total_rounds)
