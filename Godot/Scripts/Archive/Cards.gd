extends Panel

var initial_pos = Vector2.ZERO

var tween = Tween.new()

#timer to prevent some bugs from happening
var wait_timer = Timer.new()
var detecting_mouse = true


func _ready():
	connect("mouse_entered", self, "_highlight_card")
	connect("mouse_exited", self, "_play_down")
	wait_timer.connect("timeout", self, "_on_wait_timer_timeout")

	initial_pos = self.rect_position

	#creating some child nodes
	self.add_child(tween)
	self.add_child(wait_timer)
	wait_timer.one_shot = true


func _highlight_card() -> void:
	if detecting_mouse:
		tween.interpolate_property(
			self,
			"rect_position",
			self.rect_position,
			self.rect_position - Vector2(0, 150),
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		tween.interpolate_property(
			self,
			"rect_scale",
			self.rect_scale,
			self.rect_scale + Vector2(0.25, 0.25),
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
		tween.start()


func _play_down() -> void:
	tween.stop(self)
	tween.interpolate_property(
		self,
		"rect_position",
		self.rect_position,
		initial_pos,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween.interpolate_property(
		self,
		"rect_scale",
		self.rect_scale,
		Vector2(1, 1),
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween.start()
	wait_timer.start(0.1)
	detecting_mouse = false


func _on_wait_timer_timeout():
	detecting_mouse = true
	print("banana")
