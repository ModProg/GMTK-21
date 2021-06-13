extends PathFollow2D

export var element = "Water"
export var damage = 10
export var speed = 100
export var health = 25

var round_controller
var slowed_down = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#$Sprite.frames = textures[element]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	offset += speed * delta
	slowed_down = false
	if unit_offset == 1:
		round_controller.Damage(damage)
		queue_free()

func damage(p_element: String, d: float) -> void:
	if d == 0:
		return
	# Same element no damage
	var damage
	if p_element == element:
		damage = 0
	else:
		# What element is the enemy?
		match p_element:
			"Rain", "Water":  # WATER
				match element:
					"Air":  # LOW DAMAGE
						#$Sprite.modulate = Color.lightgray
						damage = .5
					"Earth":  # MEDIUM DAMAGE
						#$Sprite.modulate = Color.yellow
						damage = 1
					"Fire":  # HIGH DAMAGE
						#$Sprite.modulate = Color.red
						damage = 2
			"Air", "Tornado":  # AIR
				match element:
					"Water":  # LOW DAMAGE
						#$Sprite.modulate = Color.lightgray
						damage = .5
					"Fire":  # MEDIUM DAMAGE
						#$Sprite.modulate = Color.yellow
						damage = 1
					"Earth":  # HIGH DAMAGE
						#$Sprite.modulate = Color.red
						damage = 2
			"Earth", "Mud":  # EARTH
				match element:
					"Fire":  # LOW DAMAGE
						#$Sprite.modulate = Color.lightgray
						damage = .5
					"Air":  # MEDIUM DAMAGE
						#$Sprite.modulate = Color.yellow
						damage = 1
					"Water":  # HIGH DAMAGE
						#$Sprite.modulate = Color.red
						damage = 2
			"Fire", "Blue_Fire":  # EARTH
				match element:
					"Earth":  # LOW DAMAGE
						#$Sprite.modulate = Color.lightgray
						damage = .5
					"Water":  # MEDIUM DAMAGE
						#$Sprite.modulate = Color.yellow
						damage = 1
					"Air":  # HIGH DAMAGE
						#$Sprite.modulate = Color.red
						damage = 2
	health -= damage*d
	if health <= 0:
		print("Enemy("+element+") died to "+p_element)
		queue_free()
#	else:
#		print("Enemy("+element+") damaged("+str(damage*d)+") by "+p_element)
	$FlashTimer.start()


func _on_FlashTimer_timeout() -> void:
	pass
	#$Sprite.modulate = Color.white
