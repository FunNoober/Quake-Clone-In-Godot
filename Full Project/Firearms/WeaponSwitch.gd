extends Spatial

var current_weapon_index = 0

func _ready():
	switch_weapon(0)
#	for child in get_child_count():
#		get_child(child).hide()
#		get_child(child).get_node("UI").hide()
#		get_child(child).set_process(false)
#		get_child(child).get_node("UI").hide()
#	get_child(current_weapon_index).show()
#	get_child(current_weapon_index).set_process(true)

func _process(delta):
	if current_weapon_index == get_child_count():
		current_weapon_index = 0
	
	if Input.is_action_just_pressed("switch_weapon"):
		current_weapon_index = current_weapon_index + 1
		switch_weapon(1)
		
func switch_weapon(subtraction_index):
	for child in get_child_count():
		get_child(child).hide()
		get_child(child).get_node("UI").hide()
		get_child(child).set_process(false)
		get_child(child).get_node("UI").hide()
		
	get_child(current_weapon_index-subtraction_index).show()
	get_child(current_weapon_index-subtraction_index).get_node("UI").show()
	get_child(current_weapon_index-subtraction_index).set_process(true)
	get_child(current_weapon_index-subtraction_index).get_node("UI").set_process(true)
