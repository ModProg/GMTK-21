extends Sprite

export (String) var element = "Water"
export var speed = 200

var target_ref: WeakRef = null

const textures = {
	"Water": preload("res://Art/Projectiles/Water Projectile.tres"),
	"Air": preload("res://Art/Projectiles/Air Projectile.tres"),
	"Earth": preload("res://Art/Projectiles/Earth Projectile.tres"),
	"Fire": preload("res://Art/Projectiles/Fire Projectile.tres"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = textures[element]


func _physics_process(delta: float) -> void:
	var target = target_ref.get_ref()
	if target:
		var velocity = (target.get_global_transform().origin - position).normalized() * speed
		position += velocity * delta
	else:
		queue_free()
