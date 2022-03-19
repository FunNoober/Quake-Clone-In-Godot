extends Control

export (Array, String) var level_paths


func _on_Level1Button_pressed():
	get_tree().change_scene(level_paths[0])

func _on_Level2Button_pressed():
	get_tree().change_scene(level_paths[1])


func _on_Level3Button_pressed():
	get_tree().change_scene(level_paths[2])

func _on_QuitButton_pressed():
	get_tree().quit()
