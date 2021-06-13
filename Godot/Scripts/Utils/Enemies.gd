class_name Enemies

const enemies = {
	"Bomb": preload("res://Scenes/Enemies/Bomb.tscn"),
	"PufferFish": preload("res://Scenes/Enemies/PufferFish.tscn"),
}

static func random_enemy() -> PackedScene:
	return enemies.values()[randi() % enemies.values().size()]
