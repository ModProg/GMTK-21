extends Panel

var initial_pos = Vector2.ZERO

func _ready():
	connect("mouse_entered", self, "_highlight_card")
	connect("mouse_exited", self, "_play_down")
	initial_pos = self.rect_position

func _highlight_card() -> void:
	#self.rect_position.y -= 25
	var tween = Tween.new()
	self.add_child(tween)
	
	tween.interpolate_property(self, "rect_position", self.rect_position, self.rect_position - Vector2(0, 25), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()

func _play_down() -> void:
	#self.rect_position.y += 25
	var tween = Tween.new()
	self.add_child(tween)
	tween.interpolate_property(self, "rect_position", self.rect_position, initial_pos, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
