extends Sprite

export var element = "Water"

var target_ref: WeakRef = null
var game_controller: GameController

#kinematics
var velocity=Vector2.ZERO
var target_positon=Vector2()
var distance
var final_pos

export var earth_size: Curve

const speeds = {
	"Water": 200,
	"Air": 200,
	"Earth": 300,
	"Fire": 400,
	"Mud": 200,
	"Steam": 400,
	"Sand": 150,
	"Blue_Fire": 1,
	"Lava": 200,
	"Rain": 100,
}
var max_dist
var start_pos
var wait = true;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	final_pos = target_ref.get_ref().get_global_transform().origin
	start_pos = self.position
	if element != "Fire":
		$Fire.queue_free()
	match element:
		"Water":
			texture = preload("res://Art/Projectiles/Water Projectile.tres")
		"Air":
			wait = true
			$SelfDestruct.wait_time = 1
			$Area2D/CollisionShape2D.shape.radius = 5
			$Air.emitting = true
		"Earth":
			$SelfDestruct.wait_time = 0.5
			texture = preload("res://Art/Projectiles/Earth Projectile.tres")
			max_dist=self.position.distance_to(final_pos)
		"Fire":
			position = (final_pos-start_pos)/2 + start_pos
			rotation = (final_pos-start_pos).angle()
			$Area2D/Fire.disabled = false
			$Fire.emitting = true

func _physics_process(delta: float) -> void:
	print(scale)
	var target = target_ref.get_ref()
	if target:
		if element != "Fire":
			velocity = (target.get_global_transform().origin - position).normalized() * speeds[element]
			position += velocity * delta
		physic_according_to_element(element,target,delta)
	else:
		queue_free()

func physic_according_to_element(element,target,delta):
	final_pos=(target).get_global_transform().origin
	distance=self.position.distance_to(final_pos)
	match element:
		"Water":
			#I think of making to spawn a area 2d when it reaches the tileset
			#and set the tile set to watered tile set in that water tileset we can have 
			#an area 2d to destroy the enemies
			pass
		"Air":
			for e in enemies:
				if weakref(e).get_ref():
					e.damage(element, 10*delta)
			#change a target type to time based
			pass
		"Earth":
			scale = Vector2.ONE*earth_size.interpolate(1-distance/max_dist)

var enemies: Array = []

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var area_parent=area.get_parent()
		enemies.append(area_parent)
		if area_parent == target_ref.get_ref():
			if wait:
				$SelfDestruct.start()
			else:
				_on_SelfDestruct_timeout()


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):		
		var area_parent=area.get_parent()
		enemies.erase(area_parent)


func _on_SelfDestruct_timeout() -> void:
	match element:
		"Water":
			var inst = preload("res://Scenes/Placed.tscn").instance()
			var tm = game_controller.tile_map
			inst.position=tm.to_global(tm.map_to_world(tm.world_to_map(tm.to_local(position)))+tm.cell_size / 2)
			inst.element = element
			inst.damage = 10
			game_controller.tower_parrent.add_child(inst)
		"Earth":
			for e in enemies:
				if weakref(e).get_ref():
					e.damage(element, 10)
	if element != "Fire":
		queue_free()


func _on_Fire_particles_cycle_finished() -> void:
	if element == "Fire":
		for e in enemies:
			if weakref(e).get_ref():
				e.damage(element, 10)
		queue_free()
