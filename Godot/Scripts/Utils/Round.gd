class_name Round

var enemy_count: int
var enemy_distribution: Dictionary
var enemies: Array
var round_time: float
var spawn_time: float
var initial_spawn_time: float
var retry: bool
var music: AudioStream
var help_text: String
var modifiers: Array
var map: String

var cards: Dictionary
var cards_add: Dictionary
var card_count: int
var card_count_add: int

var health: int
var name: String

var res_enemy_count: int
var res_enemy_distribution: Dictionary
var res_enemies: Array


func get_enemy() -> PackedScene:
	if enemies.size() > 0:
		return Enemies.enemies[enemies.pop_front()]
	elif enemy_distribution.size() > 0:
		var keys = enemy_distribution.keys()
		var e = keys[randi()%keys.size()]
		if enemy_distribution[e] == 0:
			enemy_distribution.erase(e)
			return get_enemy()
		enemy_distribution[e] -= 1
		return Enemies.enemies[e]
	elif enemy_count > 0:
		enemy_count -= 1
		return Enemies.random_enemy()
	else:
		return null

func has_enemies() -> bool:
	return !(enemies.size() == 0 && enemy_distribution.size() == 0 && enemy_count == 0)

func has_cards() -> bool:
	return card_count != -1 || cards.size()>0
	
func has_add_cards() -> bool:
	return card_count_add != -1 || cards_add.size()>0
		
func get_cards_add() -> Array:
	var l_cards = cards_add.duplicate()
	var ret = []
	if card_count_add != -1:
		for _i in card_count_add:
			ret.append(Element.random_element())
		return ret
	while l_cards.size() > 0:
		var elem = l_cards.keys()[randi() % l_cards.keys().size()]
		if l_cards[elem] == 0:
			l_cards.erase(elem)
		else:
			ret.append(elem)
			l_cards[elem] -= 1
	return ret
	
func get_cards() -> Array:
	var l_cards = cards.duplicate()
	var ret = []
	if card_count != -1:
		for _i in card_count:
			ret.append(Element.random_element())
		return ret
	while l_cards.size() > 0:
		var elem = l_cards.keys()[randi() % l_cards.keys().size()]
		if l_cards[elem] == 0:
			l_cards.erase(elem)
		else:
			ret.append(elem)
			l_cards[elem] -= 1
	return ret

func from_dict(value: Dictionary) -> Round:
	if value.has("enemy_distribution"):
		res_enemy_distribution = value.enemy_distribution

	if value.has("enemies"):
			res_enemies = value.enemies

	if value.has("enemy_count"):
		res_enemy_count = value.enemy_count

	if value.has("initial_spawn_time"):
		initial_spawn_time = value.initial_spawn_time
	else:
		initial_spawn_time = value.spawn_time

	if value.has("retry"):
		retry = value.retry

	if value.has("music"):
		if value.music is String:
			music = Music.get_music_by_name(value.music)
		else:
			music = Music.get_music_by_id(value.music)
	
	if value.has("help_text"):
		help_text = value.help_text
	
	if value.has("modifiers"):
		modifiers = value.modifiers
	
	if value.has("cards"):
		cards = value.cards
		
	if value.has("name"):
		name = value.name
	
	if value.has("cards_add"):
		cards_add = value.cards_add
	
	if value.has("card_count"):
		card_count = value.card_count
	else:
		card_count = -1
	
	if value.has("map"):
		map = value.map
		
	
	if value.has("health"):
		health = value.health
		
	if value.has("card_count_add"):
		card_count_add = value.card_count_add
		
		
	
	spawn_time = value.spawn_time
	round_time = value.round_time

	reset()
	return self


func reset():
	enemy_count = res_enemy_count
	enemy_distribution = res_enemy_distribution.duplicate()
	enemies = res_enemies.duplicate()
