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
export var mud_size: Curve

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

const max_life = {
	"Water": 3,
	"Air": 3,
	"Earth": 3,
	"Fire": 3,
	"Mud": 3,
	"Steam": 3,
	"Sand": 3,
	"Blue_Fire": 3,
	"Lava": 3,
	"Rain": 3,
}
var max_dist
var start_pos
var wait = true;
var hit = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SelfDestructStart.start(max_life[element])
	print("Shooting: " + element)
	set_physics_process(true)
	final_pos = target_ref.get_ref().get_global_transform().origin
	distance=self.position.distance_to(final_pos)
	max_dist=self.position.distance_to(final_pos)
	start_pos = self.position
	if element != "Fire":
		$Fire.queue_free()
	texture = null
	match element:
		"Water":
			texture = preload("res://Art/Projectiles/Water Projectile.tres")
		"Lava":
			texture = preload("res://Art/Projectiles/Fire Projectile.tres")
		"Air":
			wait = true
			$SelfDestruct.wait_time = .5
			$Area2D/CollisionShape2D.shape.radius = 5
			$Air.emitting = true
		"Sand":
			wait = true
			$SelfDestruct.wait_time = .5
			$Area2D/CollisionShape2D.shape.radius = 5
			$Sand.emitting = true
		"Earth":
			wait = false
			$SelfDestruct.wait_time = 0.5
			texture = preload("res://Art/Projectiles/Earth Projectile.tres")
		"Mud":
			wait = false
			texture = preload("res://Art/Projectiles/Earth Projectile.tres")
		"Fire":
			position = (final_pos-start_pos)/2 + start_pos
			rotation = (final_pos-start_pos).angle()
			$Area2D/Fire.disabled = false
			$Fire.emitting = true
		"Steam":
			position = (final_pos-start_pos)/2 + start_pos
			rotation = (final_pos-start_pos).angle()
			$Area2D/Steam.disabled = false
			$Steam.emitting = true
		"Blue_Fire":
			position = (final_pos-start_pos)/2 + start_pos
			rotation = (final_pos-start_pos).angle()
			$Area2D/Blue_Fire.disabled = false
			$Blue_Fire.emitting = true
		"Rain":
			$SelfDestruct.wait_time = 4
			texture = preload("res://Art/Projectiles/Rain Projectile.tres")
			$Rain.emitting = true
			offset = Vector2(0,-8)

func _physics_process(delta: float) -> void:
	var target = target_ref.get_ref()
	if target:
		if !(element == "Fire" || element == "Steam"|| element == "Blue_Fire") :
			velocity = (target.get_global_transform().origin - position).normalized() * speeds[element]
			position += velocity * delta
		final_pos=(target).get_global_transform().origin
		if distance < 3:
			position = final_pos
			hit = true
			set_physics_process(false)
			if wait:
				$SelfDestruct.start()
			else:
				_on_SelfDestruct_timeout()
		distance=self.position.distance_to(final_pos)
		physic_according_to_element(element,target,delta)
		
	else:
		queue_free()

func physic_according_to_element(element,target,delta):
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
		"Sand":
			for e in enemies:
				if weakref(e).get_ref():
					e.damage("Air", 10*delta)
			#change a target type to time based
			pass
		"Earth":
			scale = Vector2.ONE*earth_size.interpolate(1-distance/max_dist)
		"Mud":
			scale = Vector2.ONE*mud_size.interpolate(1-distance/max_dist)
		"Rain":
			for e in enemies:
				if weakref(e).get_ref():
					if ! e.slowed_down:
						e.offset -= e.speed/2 * delta
						e.slowed_down = true
					e.damage("Water", 5*delta)

var enemies: Array = []

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var area_parent=area.get_parent()
		enemies.append(area_parent)


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):		
		var area_parent=area.get_parent()
		enemies.erase(area_parent)


func _on_SelfDestruct_timeout() -> void:
	match element:
		"Water":
			var inst = preload("res://Scenes/Placed.tscn").instance()
			var tm = game_controller.tile_map
			inst.position=final_pos#tm.to_global(tm.map_to_world(tm.world_to_map(tm.to_local(position)))+tm.cell_size / 2)
			inst.element = element
			inst.damage = 10
			game_controller.tower_parrent.add_child(inst)
		"Lava":
			var inst = preload("res://Scenes/Placed.tscn").instance()
			var tm = game_controller.tile_map
			inst.position=final_pos#tm.to_global(tm.map_to_world(tm.world_to_map(tm.to_local(position)))+tm.cell_size / 2)
			inst.element = element
			inst.damage = 10
			inst.damage_type = "Fire"
			game_controller.tower_parrent.add_child(inst)
		"Mud":
			var inst = preload("res://Scenes/Placed.tscn").instance()
			var tm = game_controller.tile_map
			inst.position=final_pos#tm.to_global(tm.map_to_world(tm.world_to_map(tm.to_local(position)))+tm.cell_size / 2)
			inst.element = element
			inst.damage_type = "Earth"
			inst.scale = Vector2.ONE*mud_size.interpolate(1)
			inst.slow_down = .5
			game_controller.tower_parrent.add_child(inst)
		"Earth":
			for e in enemies:
				if weakref(e).get_ref():
					e.damage(element, 10)
	if !(element == "Fire" || element == "Steam" || element == "Blue_Fire") :
		queue_free()


func _on_Fire_particles_cycle_finished() -> void:
	if element == "Fire":
		for e in enemies:
			if weakref(e).get_ref():
				e.damage(element, 10)
		queue_free()


func _on_Steam_particles_cycle_finished() -> void:
	if element == "Steam":
		for e in enemies:
			if weakref(e).get_ref():
				e.damage("Fire", 10)
		queue_free()

func _on_BlueFire_particles_cycle_finished() -> void:
	if element == "Blue_Fire":
		for e in enemies:
			if weakref(e).get_ref():
				e.damage("Fire", 10)
		queue_free()
