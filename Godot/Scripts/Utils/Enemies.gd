class_name Enemies

const enemies = {
	"Bomb": preload("res://Scenes/Enemies/Bomb.tscn"),
	"Flare": preload("res://Scenes/Enemies/Flare.tscn"),
	"Ghost": preload("res://Scenes/Enemies/Ghost.tscn"),
	"PufferFish": preload("res://Scenes/Enemies/PufferFish.tscn"),
	"Slime": preload("res://Scenes/Enemies/Slime.tscn"),
	"Worm": preload("res://Scenes/Enemies/Worm.tscn"),
	"Zombie": preload("res://Scenes/Enemies/Zombie.tscn"),
}

static func random_enemy() -> PackedScene:
	return enemies.values()[randi() % enemies.values().size()]
