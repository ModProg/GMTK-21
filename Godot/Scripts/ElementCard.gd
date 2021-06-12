extends TextureButton

const Tower_scene = preload("res://Scenes/Tower.tscn")

export var hand_close_speed: float = 10
export var hand_open_speed: float = hand_close_speed
export var fly_back_speed: float = 20
export var scale_down_speed: float = 10
export var scale_up_speed: float = scale_down_speed
export var padding: float = 4

var element = Element.random_element()
var game_controller: GameController

onready var parent: Control = $".."
var parent_rect_min_size: Vector2
var attached = false
var tower_instance: Node

var texture = {
	"Water": preload("res://Art/Cards/Water Card.tres"),
	"Earth": preload("res://Art/Cards/Earth Card.tres"),
	"Air": preload("res://Art/Cards/Air Card.tres"),
	"Fire": preload("res://Art/Cards/Fire Card.tres")
}


func _ready() -> void:
	texture_normal = texture[element]

	parent_rect_min_size = rect_min_size + Vector2(padding * 2, 0)
	parent.rect_min_size = parent_rect_min_size


func _process(delta: float) -> void:
	if attached:
		parent.rect_min_size.x = lerp(parent.rect_min_size.x, 0, hand_close_speed * delta)
		rect_global_position = get_global_mouse_position() - rect_scale * rect_size / 2
		rect_scale = lerp(rect_scale, Vector2.ZERO, scale_down_speed * delta)
	else:
		parent.rect_min_size.x = lerp(
			parent.rect_min_size.x, parent_rect_min_size.x, hand_open_speed * delta
		)
		rect_global_position = lerp(
			rect_global_position, parent.rect_global_position, fly_back_speed * delta
		)
		rect_scale = lerp(rect_scale, Vector2.ONE, scale_up_speed * delta)


func _on_ElementCard_button_down() -> void:
	attached = true
	tower_instance = Tower_scene.instance()
	tower_instance.element = element
	tower_instance.texture = tower_instance.textures[element]
	game_controller.add_tower(tower_instance)


func _on_ElementCard_button_up() -> void:
	if tower_instance.try_place():
		parent.queue_free()
	else:
		attached = false
