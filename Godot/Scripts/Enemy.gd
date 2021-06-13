extends PathFollow2D

export var element = "Water"
export var damage = 10
export var speed = 100
export var health = 25

var round_controller

const textures = {
	"Water": preload("res://Art/Enemies/Water Enemy.tres"),
	"Air": preload("res://Art/Enemies/Air Enemy.tres"),
	"Earth": preload("res://Art/Enemies/Earth Enemy.tres"),
	"Fire": preload("res://Art/Enemies/Fire Enemy.tres"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = textures[element]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	offset += speed * delta
	if unit_offset == 1:
		round_controller.Damage(damage)
		queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		# Same element no damage
		# if projectile.element == element:
		# 	$Sprite.modulate = Color.white
		# 	damage = 0
		# else:
		# 	# What element is the enemy?
		# 	match projectile.element:
		# 		0:  # WATER
		# 			match element:
		# 				2:  # MEDIUM DAMAGE
		# 					$Sprite.modulate = Color.yellow
		# 					damage = 10
		# 				3:  # HIGH DAMAGE
		# 					$Sprite.modulate = Color.red
		# 					damage = 20
		# 		1:  # AIR
		# 			match element:
		# 				2:  # HIGH DAMAGE
		# 					$Sprite.modulate = Color.red
		# 					damage = 20
		# 				3:  # MEDIUM DAMAGE
		# 					$Sprite.modulate = Color.yellow
		# 					damage = 10
		# 		2:  # EARTH
		# 			match element:
		# 				0:  # HIGH DAMAGE
		# 					$Sprite.modulate = Color.red
		# 					damage = 20
		# 				1:  # MEDIUM DAMAGE
		# 					$Sprite.modulate = Color.yellow
		# 					damage = 10
		# 		3:  # FIRE
		# 			match element:
		# 				0:  # MEDIUM DAMAGE
		# 					$Sprite.modulate = Color.yellow
		# 					damage = 10
		# 				1:  # HIGH DAMAGE
		# 					$Sprite.modulate = Color.red
		# 					damage = 20

		# Destroy the projectile
		print(area)
		health -= 10
		area.get_parent().queue_free()
		if health <= 0:
			queue_free()
		$Sprite.modulate = Color.darkgray
		$FlashTimer.start()


func _on_FlashTimer_timeout() -> void:
	$Sprite.modulate = Color.white
