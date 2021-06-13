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
onready var messageText = $MarginContainer3/RPGLabel
onready var cardContainer: HBoxContainer = $MarginContainer2/Row
var game_controller

var card_scene = preload("res://Scenes/UI/ElementCard.tscn")

func start() -> void:
	pass
	#towerTables.game_controller = game_controller


func set_message(value: String):
	Text.iconize(messageText,value)
	messageText.print_on = true
	messageText.print_speed = 30
	messageText.visible_characters = 0
	messageText.percent_visible = 0

func set_cards(value: Array):
	for c in cardContainer.get_children():
		c.queue_free()
	add_cards(value)

func add_cards(value: Array):
	for card in value:
		if cardContainer.get_child_count() < 8:
			var inst = card_scene.instance()
			inst.get_child(0).game_controller = game_controller
			inst.get_child(0).element = card
			cardContainer.add_child(inst)

func set_health(value: int):
	_health = value
	healthText.text = '\nHealth: ' + str(_health) + ' / ' + str(_max_health)

func set_max_health(value: int):
	_max_health = value
	healthText.text = '\nHealth: ' + str(_health) + ' / ' + str(_max_health)


func set_total_rounds(value: int):
	_total_rounds = value
	roundText.text = 'Round ' + str(_current_round) + "/" + str(_total_rounds)


func set_current_round(value: int):
	_current_round = value
	roundText.text = 'Round ' + str(_current_round) + "/" + str(_total_rounds)
