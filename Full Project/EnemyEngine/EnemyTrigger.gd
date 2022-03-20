extends Node

export (Array, NodePath) var enemies_to_change

func _on_EnemyTrigger_body_entered(body):
	if body.is_in_group("Player") == true:
		for i in len(enemies_to_change):
			if get_node(enemies_to_change[i]) != null:
				get_node(enemies_to_change[i]).has_seen_enemy = true
