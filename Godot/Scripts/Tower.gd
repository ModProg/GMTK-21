extends Sprite

var element:String = "Fire"
export var building = false

var tile_map

var targets = []
var current_target: WeakRef
var game_controller
var ex_tower: Node2D


const textures = {
	"Water": preload("res://Art/Towers/Water Tower.tres"),
	"Air": preload("res://Art/Towers/Air Tower.tres"),
	"Earth": preload("res://Art/Towers/Earth Tower.tres"),
	"Fire": preload("res://Art/Towers/Fire Tower.tres"),
	"Mud": preload("res://Art/Towers/Mud Tower.tres"),
	"Steam": preload("res://Art/Towers/Steam Tower.tres"),
	"Sand": preload("res://Art/Towers/Sand Tower.tres"),
	"Blue_Fire": preload("res://Art/Towers/Blue_Fire Tower.tres"),
	"Lava": preload("res://Art/Towers/Lava Tower.tres"),
	"Rain": preload("res://Art/Towers/Rain Tower.tres"),
}
const projectile = preload("res://Scenes/Projectile.tscn")

const cooldowns = {
	"Water": 1,
	"Air": 1,
	"Earth": .3,
	"Fire": .5,
	"Mud": 2,
	"Steam": 1,
	"Sand": 3,
	"Blue_Fire": 2,
	"Lava": .1,
	"Rain": 2,
}

const ranges = {
	"Water": 20,
	"Air": 30,
	"Earth": 25,
	"Fire": 6,
	"Mud": 20,
	"Steam": 10,
	"Sand": 10,
	"Blue_Fire": 10,
	"Lava": 10,
	"Rain": 10,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Area2D/CollisionShape2D".shape.radius = ranges[element]


func try_place() -> bool:
	# reset ex_tower if existing
	if ex_tower:
		ex_tower.visible = true
		ex_tower = null
	var tile_pos = tile_map.world_to_map(tile_map.get_local_mouse_position())
	if Tile.is_build_able(tile_map.get_cellv(tile_pos)):
		var l_ex_tower = game_controller.get_tower(tile_pos)
		if l_ex_tower:
			var combined = Element.combine(l_ex_tower.element, element)
			if ! combined.empty() && ! game_controller.modifiers.has("no_combine"):
				l_ex_tower.element = combined
				l_ex_tower.get_node("ShootTimer").wait_time = cooldowns[element]
				l_ex_tower.texture = textures[combined]
				l_ex_tower.get_node("Area2D/CollisionShape2D").shape.radius = ranges[combined]
				queue_free()
				return true
			else:
				queue_free()
				return false
		else:
			game_controller.set_tower(tile_pos, self)
			global_position = tile_map.to_global(
				tile_map.map_to_world(tile_pos) + tile_map.cell_size / 2
			)
			building = false
			return true
	queue_free()
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if ex_tower:
		ex_tower.visible = true
		ex_tower = null
		texture = textures[element]
	if building:
		var tile_pos = tile_map.world_to_map(tile_map.get_local_mouse_position())
		if Tile.is_build_able(tile_map.get_cellv(tile_pos)):
			global_position = tile_map.to_global(
				tile_map.map_to_world(tile_pos) + tile_map.cell_size / 2
			)
			modulate = Color.white
			ex_tower = game_controller.get_tower(tile_pos)
			if ex_tower:
				var combined = Element.combine(ex_tower.element, element)
				if ! combined.empty() && ! game_controller.modifiers.has("no_combine"):
					ex_tower.visible = false
					texture = textures[combined]
				else:
					position = get_global_mouse_position()
					modulate = Color.black
		else:
			position = get_global_mouse_position()
			modulate = Color.black
	else:
		if ! current_target:
			var dist = INF
			for target in targets:
				var cdist = (position - target.get_global_transform().origin).length()
				if dist > cdist:
					dist = cdist
					current_target = weakref(target)
		if current_target:
			if $ShootTimer.is_stopped():
				_on_ShootTimer_timeout()
				$ShootTimer.start(cooldowns[element])
			var target = current_target.get_ref()
			if ! target:
				current_target = null
			else:
				if targets.find(target) == -1:
					current_target = null
				else:
					var target_position = target.get_global_transform().origin
					var target_rotation = (target_position - global_position).angle()
					rotation = lerp_angle(rotation, target_rotation, 0.1)


# This needs to also run while building 
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") && area.get_parent().element != element:
		targets.append(area.get_parent())


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.erase(area.get_parent())


func _on_ShootTimer_timeout() -> void:
	if current_target:
		var target = current_target.get_ref()
		if target:
			var instance = projectile.instance()
			instance.element = element
			instance.position = position
			instance.target_ref = current_target
			instance.element = element
			instance.game_controller = game_controller
			get_parent().add_child(instance)
	else:
		$ShootTimer.stop()
