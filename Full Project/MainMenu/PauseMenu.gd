extends Control

var has_paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()
		
func pause():
	if has_paused == false:
		self.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		has_paused = true
		Engine.time_scale = 0
		return
	else:
		self.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		has_paused = false
		Engine.time_scale = 1
		return


func _on_ResumeButton_pressed():
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	has_paused = false
	Engine.time_scale = 1
	return


func _on_MainMenuButton_pressed():
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
