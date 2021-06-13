extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var element
var damage = 0
var damage_type = element
var slow_down = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not damage_type:
		damage_type = element
	match element:
		"Water": 
			texture = preload("res://Art/Projectiles/Water Placed.tres")
		"Mud": 
			texture = preload("res://Art/Projectiles/Earth Projectile.tres")
		"Lava": 
			texture = preload("res://Art/Projectiles/Fire Projectile.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for e in enemies:
		if weakref(e).get_ref():
			e.damage(damage_type, damage*delta)
			if ! e.slowed_down:
				e.offset -= e.speed*slow_down*delta
				e.slowed_down = true

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
