class_name Element

const basic = ["Water", "Earth", "Air", "Fire"]

static func random_element() -> String:
	return basic[randi() % basic.size()]

const combinations = {
	["Water", "Air"]: "Rain",
	["Water", "Earth"]: "Mud",
	["Water", "Fire"]: "Steam",
	["Air", "Earth"]: "Sand",
	["Air", "Fire"]: "Blue_Fire",
	["Earth", "Fire"]: "Lava"
}

static func combine(element1: String, element2: String) -> String:
	if combinations.has([element1, element2]):
		return combinations[[element1, element2]]
	if combinations.has([element2, element1]):
		return combinations[[element2, element1]]
	return ""
