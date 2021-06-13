extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var element
var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match element:
		"Water": 
			texture = preload("res://Art/Projectiles/Water Placed.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for e in enemies:
		if weakref(e).get_ref():
			e.damage(element, damage*delta)

var enemies = []

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var area_parent=area.get_parent()
		enemies.append(area_parent)


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):		
		var area_parent=area.get_parent()
		enemies.erase(area_parent)


func _on_Timer_timeout() -> void:
	queue_free()
