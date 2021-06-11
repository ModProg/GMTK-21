extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var building = false;
onready var tilemap = $"../../TileMap";
var targets = [];
var current_target: WeakRef;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if building:
		var tile_pos = tilemap.world_to_map(tilemap.get_local_mouse_position())
		if tilemap.get_cellv(tile_pos) == 1:
			global_position = tilemap.to_global(tilemap.to_global(tile_pos)+tilemap.cell_size/2)
			modulate = Color.white
		else:
			global_position = get_global_mouse_position()
			modulate = Color.red
	else:
		if !current_target:
			var dist = INF
			for target in targets:
				var cdist =(position - target.get_global_transform().origin).length()
				if(dist > cdist):
					dist = cdist;
					current_target = weakref(target)
		if current_target:
			if(!current_target.get_ref()):
				current_target = null
			else:
				if targets.find(current_target.get_ref()) == -1:
					current_target = null
				else:
					current_target.get_ref().queue_free()
	
func _input(event: InputEvent) -> void:
	if building && event is InputEventMouseButton && event.button_index == 1:
		var tile_pos = tilemap.world_to_map(tilemap.get_local_mouse_position())
		if tilemap.get_cellv(tile_pos) == 1:
			global_position = tilemap.to_global(tilemap.to_global(tile_pos)+tilemap.cell_size/2)
			tilemap.set_cellv(tile_pos, 2)
			building = false;


# This needs to also run while building 
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.append(area.get_parent())


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		targets.erase(area.get_parent())
