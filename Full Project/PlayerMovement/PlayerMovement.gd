extends KinematicBody


var speed = 5.0
var jump_speed = 10
var max_speed = 20.0
var dir = Vector3()
var cam : Node
var cam_hold : Node
var vel = Vector3()

var GRAVITY = -9

const ACCEL = 20
const DEACCEL = 20
const MOUSE_SENSITIVITY = 1
const MAX_SLOPE_ANGLE = 40

var health
var time = 0.0

func _ready():
	get_tree().get_root().get_child(0).get_node("FinishLevelTrigger").connect("player_detected", self, "show_finish")
	cam = $CameraHolder/Camera
	cam_hold = $CameraHolder
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health = 100
	
func _process(delta):
	time += delta
	$UserInterface/Timer.text = str(stepify(time, 0.01))
	if health <= 0:
		get_tree().reload_current_scene()

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	dir = Vector3()
	var cam_xform = cam.get_global_transform()
	
	var input_mv_vec = Vector2()
	
	if Input.is_action_pressed("mv_forward"):
		input_mv_vec.y += 1
	if Input.is_action_pressed("mv_back"):
		input_mv_vec.y -= 1
	if Input.is_action_pressed("mv_right"):
		input_mv_vec.x += 1
		cam_hold.rotation_degrees.z = lerp(cam_hold.rotation_degrees.z, 3.6, 2 * delta)
	if Input.is_action_pressed("mv_left"):
		input_mv_vec.x -= 1
		cam_hold.rotation_degrees.z = lerp(cam_hold.rotation_degrees.z, -3.6, 2 * delta)
		
	if Input.is_action_pressed("mv_left") == false or Input.is_action_pressed("mv_right") == false:
		cam_hold.rotation_degrees.z = lerp(cam_hold.rotation_degrees.z, 0, 2 * delta)
		
	input_mv_vec = input_mv_vec.normalized()
	
	dir += -cam_xform.basis.z * input_mv_vec.y
	dir += cam_xform.basis.x * input_mv_vec.x
	
	if is_on_floor():
		if Input.is_action_just_pressed("mv_jump"):
			vel.y = jump_speed
	
func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= max_speed
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam_hold.rotate_x(deg2rad(event.relative.y * -MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var cam_rot = cam_hold.rotation_degrees
		cam_rot.x = clamp(cam_rot.x, -70, 70)
		cam_rot.y = 180
		cam_hold.rotation_degrees = cam_rot

func take_damage(amount):
	health -= amount
	$UserInterface/DamageOverlay.show()
	$UserInterface/DamageTimer.start()


func _on_DamageTimer_timeout():
	$UserInterface/DamageOverlay.hide()
	
func show_finish():
	$FinishMenu.show()
	$FinishMenu/Buttons/Lables/TimeLabel.text = str(stepify(time, 0.01))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Engine.time_scale = 0


func _on_MainMenuButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Engine.time_scale = 1
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
