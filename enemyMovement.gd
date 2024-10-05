extends CharacterBody2D

class_name EnemyBody
@export var leftX: int;
@export var rightX: int;
@export var startX: int;
var gotHit: bool;
@onready var anim = $"../Enemy2/AnimatedSprite2D"
var moveRight: bool;

func _ready(): 
	position.x = startX;
	moveRight = true;
	gotHit = false;

func _move(delta):
	if position.x <= leftX:
		moveRight = true;
	elif position.x >= rightX:
		moveRight = false;
	if !Global.gotHit && !Global.playerGotHit:
		if moveRight:
			velocity.x=20;
			anim.play("idle")
			anim.flip_h=0
		elif !moveRight:
			velocity.x=-20;
			anim.play("idle")
			anim.flip_h=-1
	elif Global.playerGotHit:
		velocity.x = 0;

func _physics_process(delta):
	_move(delta);
	move_and_slide();
	
