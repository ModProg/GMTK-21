extends Sprite

signal change_texture(texture_name)

enum combined_element{Water_Air,Earth_Water,Earth_Fire,Earth_Air,Fire_Water,Air_Fire}

export (String) var element = "Fire"
export var building = false

onready var tilemap = $"../../Map/TileMap"

var targets = []
var current_target: WeakRef
var placed=false
var over_lapping_with_towers=false
var combined=false


const textures = {
	"Water": preload("res://Art/Towers/Water Tower.tres"),
	"Air": preload("res://Art/Towers/Air Tower.tres"),
	"Earth": preload("res://Art/Towers/Earth Tower.tres"),
	"Fire": preload("res://Art/Towers/Fire Tower.tres"),
	"Wood":1,
	"Steam":2,
	"Sand":3,
	"Blue_fire":4,
	"Lava":5,
	"Ice":6,
}
const projectile = preload("res://Scenes/Projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("change_texture",self,"on_chaning_texture")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if building:
		var tile_pos = tilemap.world_to_map(tilemap.get_local_mouse_position())
		if tilemap.get_cellv(tile_pos) == 1:
			global_position = tilemap.to_global(tilemap.to_global(tile_pos) + tilemap.cell_size / 2)
			modulate = Color.white
		else:
			global_position = get_global_mouse_position()
			modulate = Color.black
	else:
		if ! current_target:
			var dist = INF
			for target in targets:
				var cdist =(position - target.get_global_transform().origin).length()
				if(dist > cdist):
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
					rotation = (target_position - position).angle()


func _input(event: InputEvent) -> void:
	if building && event is InputEventMouseButton && event.button_index == 1:
		var tile_pos = tilemap.world_to_map(tilemap.get_local_mouse_position())
		if tilemap.get_cellv(tile_pos) == 1:
			global_position = tilemap.to_global(tilemap.to_global(tile_pos) + tilemap.cell_size / 2)
			tilemap.set_cellv(tile_pos, 2)
			building = false


# This needs to also run while building 
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.append(area.get_parent())


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.erase(area.get_parent())
	if area.is_in_group("Tower"):
		print("Hello my dear")

func _on_ShootTimer_timeout() -> void:
	if current_target:
		var target = current_target.get_ref()
		if target:
			var instance = projectile.instance()
			instance.position = position
			instance.target_ref = current_target
			instance.element = element
			get_parent().add_child(instance)

func on_chaning_texture(texture_name):
	texture=textures[texture_name]
