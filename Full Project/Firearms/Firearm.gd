extends Spatial

export var w_ammo : int
export var w_fire_rate : float
export var w_damage : float
export var w_range : float

var ready_to_shoot : bool = true

export var shoot_casts_path : NodePath
var shoot_casts

export var muzzle_flash_path : NodePath
var muzzle_flash

func _ready():
	$FireRate.wait_time = w_fire_rate
	
	muzzle_flash = get_node(muzzle_flash_path)
	shoot_casts = get_node(shoot_casts_path)

func _process(delta):
	$UI/AmmoLabel.text = str("Ammo: " + str(w_ammo))
	
	if Input.is_action_pressed("shoot") and w_ammo > 0 and ready_to_shoot == true:
		ready_to_shoot = false
		muzzle_flash.show()
		w_ammo -= 1
		$SoundEffect.play()
		$MuzzleTimer.start()
		for i in range(shoot_casts.get_child_count()):
			var shoot_cast = shoot_casts.get_child(i)
			shoot_cast.cast_to.z = w_range
			if shoot_cast.is_colliding() == true and shoot_cast.get_collider().is_in_group("Enemy"):
				shoot_cast.get_collider().take_damage(w_damage)
				show_hit_marker()
		$FireRate.start()


func _on_FireRate_timeout():		
	ready_to_shoot = true

func _on_MuzzleTimer_timeout():
	muzzle_flash.hide()

func show_hit_marker():
	$UI/HitMarker.show()
	$UI/HitMarkerTimer.start()


func _on_HitMarkerTimer_timeout():
	$UI/HitMarker.hide()
