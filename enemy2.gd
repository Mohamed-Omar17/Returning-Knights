extends Area2D

var health = Global.enemyHealth;
@export var inAttackRange = false;
var canBeDamaged = true;


func _physics_process(delta):
	if inAttackRange:
		if Input.is_action_just_pressed("attack") && canBeDamaged:
			Global.gotHit = true;
			canBeDamaged = false;
			await get_tree().create_timer(0.4).timeout
			health-=1;
			Global.gotHit = false;
			canBeDamaged = true;
	if health == 0:
		$"..".hide()
		$CollisionShape2D.set_disabled(true);
	if !Global.playerAlive:
		await get_tree().create_timer(0.5).timeout
		health = 3;
		$"..".show()
		$CollisionShape2D.set_disabled(false);


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		inAttackRange = true;


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCollision:
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(1).timeout
			Global.playerGotHit = false;


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerCollision:
		Global.playerCanBeHit = false;


func _on_area_exited(area: Area2D) -> void:
		if area.is_in_group("player"):
			inAttackRange = false;
