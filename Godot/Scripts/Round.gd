class_name Round

enum Element { Water, Air, Earth, Fire }

enum JSONElement { water, air, earth, fire }

var enemy_count: int
var enemy_distribution: Dictionary
var enemies: Array
var round_time: float
var spawn_time: float
var initial_spawn_time: float

func get_enemy() -> int:
	if enemies.size() > 0:
		return enemies.pop_front()
	elif enemy_distribution.size() >0:
		var keys = enemy_distribution.keys()
		var e = keys[rand_range(0, keys.size())]
		if enemy_distribution[e] == 0:
			enemy_distribution.erase(e)
			return get_enemy()
		enemy_distribution[e] -= 1
		return e
	elif enemy_count > 0:
		enemy_count -= 1
		return Element.values()[rand_range(0, Element.keys().size())]
	else:
		return -1

func from_dict(value: Dictionary) -> Round:
	if value.has("enemy_distribution"):
		var ed = value.enemy_distribution
		for e in JSONElement.keys():
			if ed.has(e):
				 enemy_distribution[JSONElement[e]] = ed[e]
			else:
				 enemy_distribution[JSONElement[e]] = 0
	if value.has("enemies"):
		var es = value.enemies
		for e in es:
			 enemies.append(JSONElement[e])
	if value.has("enemy_count"):
		 enemy_count = value.enemy_count
	if not value.has("initial_spawn_time"):
		 initial_spawn_time = value.spawn_time
	else:
		 initial_spawn_time = value.initial_spawn_time
	spawn_time = value.spawn_time
	round_time = value.round_time
	return self
