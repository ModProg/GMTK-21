extends PathFollow2D

enum Element {Water, Air, Earth, Fire}

export(Element) var element = Element.Water
export var speed = 1;

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const textures = {
	Element.Water: preload("res://Art/Enemies/Water Enemy.tres"),
	Element.Air: preload("res://Art/Enemies/Air Enemy.tres"),
	Element.Earth: preload("res://Art/Enemies/Earth Enemy.tres"),
	Element.Fire: preload("res://Art/Enemies/Fire Enemy.tres"),
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = textures[element]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset+=speed*delta
	if unit_offset==1:
		queue_free()


