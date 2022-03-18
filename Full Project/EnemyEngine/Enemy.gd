extends KinematicBody

var has_seen_enemy : bool
var can_shoot : bool = true

export var player_path : NodePath
export var damage : float
export var accuracy: float

var player

var health : float
var shoot_cast

func _ready():
	player = get_node(player_path)
	health = 100
	shoot_cast = $Visuals/GunVisual/ShootCast

func _process(delta):
	if $VisionCast.is_colliding() == true:
		if $VisionCast.get_collider().is_in_group("Player"):
			has_seen_enemy = true
	if has_seen_enemy == true:
		$EnemyPos.translation = lerp($EnemyPos.translation, player.translation, delta*accuracy)
		look_at(player.translation, Vector3.UP)
		shoot_cast.look_at($EnemyPos.translation, Vector3.UP)
		shoot()
		
	if health <= 0:
		queue_free()
		
func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func shoot():
	if can_shoot == true:
		can_shoot = false
		if shoot_cast.is_colliding() == true:
			if shoot_cast.get_collider().is_in_group("Player"):
				shoot_cast.get_collider().take_damage(damage)
		$Visuals/GunVisual/ShootTimer.start()
		
		$Visuals/GunVisual/MuzzleFlash.show()
		$MuzzleTimer.start()
		

func _on_ShootTimer_timeout():
	can_shoot = true


func _on_MuzzleTimer_timeout():
	$Visuals/GunVisual/MuzzleFlash.hide()
