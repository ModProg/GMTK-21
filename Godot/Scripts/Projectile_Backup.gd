extends AnimatedSprite

export var element = "Water"
export var speed = 200

var target_ref: WeakRef = null


#kinematics
var velocity=Vector2.ZERO
var target_positon=Vector2()
var distance
var final_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frames = load("res://Art/Projectiles/"+element+".tres")
	pass


func _physics_process(delta: float) -> void:
	var target = target_ref.get_ref()
	if target:
		velocity = (target.get_global_transform().origin - position).normalized() * speed
		position += velocity * delta
	else:
		queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().damage(element, 10)
		if area.get_parent() == target_ref.get_ref():
			queue_free()

