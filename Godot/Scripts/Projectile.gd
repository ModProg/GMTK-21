extends Sprite

enum Element { Water, Air, Earth, Fire }
export (Element) var element = Element.Water
export var speed = 200

var target_ref: WeakRef = null


#kinematics
var velocity=0.0
var target_positon=Vector2()
var distance
var final_pos

const textures = {
	Element.Water: preload("res://Art/Projectiles/Water Projectile.tres"),
	Element.Air: preload("res://Art/Projectiles/Air Projectile.tres"),
	Element.Earth: preload("res://Art/Projectiles/Earth Projectile.tres"),
	Element.Fire: preload("res://Art/Projectiles/Fire Projectile.tres"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(element)
	pass


func _physics_process(delta: float) -> void:
	var target = target_ref.get_ref()
	if target:
		velocity = (target.get_global_transform().origin - position).normalized() * speed
		position += velocity * delta
		physic_according_to_element(element,target)
	else:
		queue_free()

func assgin_enum_value(param):
	match param:
		"Water":
			element = Element.Water
		"Fire":
			element = Element.Fire
		"Air":
			element = Element.Air
		"Earth":
			element = Element.Earth
	texture = textures[element]

func physic_according_to_element(element,target):
	final_pos=(target).get_global_transform().origin
	distance=self.position.distance_to(final_pos)
	match element:
		"Water":
			#I think of making to spawn a area 2d when it reaches the tileset
			#and set the tile set to watered tile set in that water tileset we can have 
			#an area 2d to destroy the enemies
			pass
		"Air":
			#change a target type to time based
			pass
		"Fire":
			if distance<90:
				$Animation_player.play("Fire")
				#play a boom animation
			#play a animation that explodes
		"Earth":
			#calput stuff so that we can make user to fake 3d like in art making the 
			#rock to rise and then we can put that animation here
			var time=distance/velocity
			#play assending animation
			yield(get_tree().create_timer(time/2),"timeout")
			#play decending animation


func _on_Destroyarea_area_entered(area):
	if area.is_in_group("enemy"):
		var area_parent=area.get_parent().get_parent()
		area_parent.health-=20
