extends Area2D

var health = Global.enemyHealth;

var inAttackRange = false;
var canBeDamaged = true;
@onready var HitSoundEffect = $"../../EnemyHit"

func _on_area_exited(area: Node) -> void:
	if area.is_in_group("player"):
		inAttackRange = false;
	if area.is_in_group("hitFromRight"):
		Global.hitFromRight = false;
	if area.is_in_group("hitFromLeft"):
		Global.hitFromLeft = false;

func _on_area_Enemy1Area_exited(area: Node) -> void:
	if area.is_in_group("player"):
		inAttackRange = false;
	if area.is_in_group("hitFromRight"):
		Global.hitFromRight = false;
	if area.is_in_group("hitFromLeft"):
		Global.hitFromLeft = false;
		
func _physics_process(delta):
	if inAttackRange:
		if Input.is_action_just_pressed("attack") && canBeDamaged:
			Global.gotHit = true;
			canBeDamaged = false;
			health-=1;
			HitSoundEffect.play();
			Global.gotHit = false;
			canBeDamaged = true;

	if health == 0:
		Global.playerCanBeHit = false;
		await get_tree().create_timer(0.4).timeout
		$"..".hide()
		inAttackRange = false;
		$CollisionShape2D.set_disabled(true);
	if !Global.playerAlive:
		await get_tree().create_timer(0.5).timeout
		health = 3;
		$"..".show()
		$CollisionShape2D.set_disabled(false);




func _on_body_exited(body: Node2D) -> void:
	if body is PlayerCollision:
		Global.playerCanBeHit = false;
		print(Global.playerCanBeHit)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		inAttackRange = true;
	if area.is_in_group("hitFromRight"):
		Global.hitFromRight = true;
	if area.is_in_group("hitFromLeft"):
		Global.hitFromLeft = true;
	if area.is_in_group("playerCollision") && Global.hitFromRight:
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(0.5).timeout
			Global.playerGotHit = false;
			Global.playerCanBeHit = false;
	elif area.is_in_group("playerCollision") && Global.hitFromLeft:
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(0.5).timeout
			Global.playerGotHit = false;
			Global.playerCanBeHit = false;
	elif area.is_in_group("playerCollision") && !Global.hitFromLeft && !Global.hitFromRight: 
		Global.hitFromRight = true;
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(0.5).timeout
			Global.playerGotHit = false;
			Global.playerCanBeHit = false;


func _on_area_Enemy1Area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		inAttackRange = true;
	if area.is_in_group("hitFromRight"):
		Global.hitFromRight = true;
	if area.is_in_group("hitFromLeft"):
		Global.hitFromLeft = true;
	if area.is_in_group("playerCollision") && Global.hitFromRight:
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(1).timeout
			Global.playerGotHit = false;
			Global.playerCanBeHit = false;
	elif area.is_in_group("playerCollision") && Global.hitFromLeft:
		Global.playerCanBeHit = true;
		if Global.playerCanBeHit && !Global.playerGotHit:
			Global.playerHealth -=1
			Global.playerGotHit = true;
			await get_tree().create_timer(1).timeout
			Global.playerGotHit = false;
			Global.playerCanBeHit = false;
