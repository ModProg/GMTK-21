extends Sprite

enum combined_element { Water_Air, Earth_Water, Earth_Fire, Earth_Air, Fire_Water, Air_Fire }

export (String) var element = "Fire"
export var building = false

onready var tile_map = $"../Map/TileMap"

var targets = []
var current_target: WeakRef
var game_controller: GameController
var placed = false
var over_lapping_with_towers = false
var combined = ""

const textures = {
	"Water": preload("res://Art/Towers/Water Tower.tres"),
	"Air": preload("res://Art/Towers/Air Tower.tres"),
	"Earth": preload("res://Art/Towers/Earth Tower.tres"),
	"Fire": preload("res://Art/Towers/Fire Tower.tres"),
	"Wood": 1,
	"Steam": 2,
	"Sand": 3,
	"Blue_Fire": 4,
	"Lava": 5,
	"Ice": 6,
}
const projectile = preload("res://Scenes/Projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if building:
		var tile_pos = tile_map.world_to_map(tile_map.get_local_mouse_position())
		if tile_map.get_cellv(tile_pos) == 1:
			global_position = tile_map.to_global(
				tile_map.map_to_world(tile_pos) + tile_map.cell_size / 2
			)
			modulate = Color.white
		else:
			position = get_global_mouse_position()
			modulate = Color.black
			if Input.is_action_just_released("Click"):
				if combined != "":
					var result = element + combined
					on_combining(return_combined_tower(result))
				queue_free()
	else:
		if ! current_target:
			var dist = INF
			for target in targets:
				var cdist = (position - target.get_global_transform().origin).length()
				if dist > cdist:
					dist = cdist
					current_target = weakref(target)
			if current_target:
				$ShootTimer.start()
		if current_target:
			var target = current_target.get_ref()
			if ! target:
				current_target = null
			else:
				if targets.find(target) == -1:
					current_target = null
				else:
					var target_position = target.get_global_transform().origin
					var target_rotation=(target_position-global_position).angle()
					rotation=lerp_angle(rotation,target_rotation,0.1)


func _input(event: InputEvent) -> void:
	if building && event is InputEventMouseButton && event.button_index == 1:
		var tile_pos = tile_map.world_to_map(tile_map.get_local_mouse_position())
		if tile_map.get_cellv(tile_pos) == 1:
			global_position = tile_map.to_global(
				tile_map.map_to_world(tile_pos) + tile_map.cell_size / 2
			)
			tile_map.set_cellv(tile_pos, 2)
			building = false


# This needs to also run while building 
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.append(area.get_parent())


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.erase(area.get_parent())


func _on_ShootTimer_timeout() -> void:
	if current_target:
		var target = current_target.get_ref()
		if target:
			var instance = projectile.instance()
			instance.position = position
			instance.element = instance.assgin_enum_value(element)
			instance.target_ref = current_target
			instance.element = element
			get_parent().add_child(instance)


func _unhandled_input(event):
	if event.is_action_released("Click") && combined != "":
		var result = element + combined
		print(result)


#when other tower enters
func _on_Combine_area_area_entered(area):
	var parent = area.get_parent()
	if area.is_in_group("Combine_Area"):
		over_lapping_with_towers = true
		combined = parent.element


#when other towers exits
func _on_Combine_area_area_exited(area):
	if area.is_in_group("Combine_Area"):
		over_lapping_with_towers = false
		combined = ""


func return_combined_tower(result):
	if result in ["WaterAir", "AirWater"]:
		return "Ice"
	elif result in ["WaterEarth", "EarthWater"]:
		return "Wood"
	elif result in ["WaterFire", "FireWater"]:
		return "Steam"
	elif result in ["AirEarth", "EarthAir"]:
		return "Sand"
	elif result in ["AirFire", "FireAir"]:
		return "Blue_Fire"
	elif result in ["EarthFire", "FireEarth"]:
		return "Lava"
	else:
		return null


func on_combining(combined_thing):
	#element=combined_thing
	#texture=textures[combined_thing]
	print("****NOW I AM A" + str(combined_thing) + "TOWER I FEEL STRONG****")
