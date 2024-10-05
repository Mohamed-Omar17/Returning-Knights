extends Area2D


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("enemies"): #&& (Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_left")):
		if (Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_right")) && Global.onFloor:
			Global.inAttackRange = true;
		else:
			Global.inAttackRange = false;


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemies"): #&& (Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_left")):
		Global.inAttackRange = false;
