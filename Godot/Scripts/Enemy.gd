extends PathFollow2D

enum Element {Water, Air, Earth, Fire}

export(Element) var element = Element.Water
export var damage = 10;
export var speed = 100;
export var health = 25;

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
func _physics_process(delta: float) -> void:
	offset+=speed*delta
	if unit_offset==1:
		get_parent().Damage(damage)
		queue_free()




func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		print(area)
		area.get_parent().queue_free()
		health -= 10
		if health <= 0:
			queue_free()
		$Sprite.modulate = Color.darkgray
		$FlashTimer.start()


func _on_FlashTimer_timeout() -> void:
	$Sprite.modulate = Color.white
