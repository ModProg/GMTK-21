extends PathFollow2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var speed = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset+=speed*delta
	if unit_offset==1:
		queue_free()


