extends CharacterBody2D

class_name Player

@onready var coyoteJumpTimer = $CoyoteJumpTimer
@onready var jumpSound = $JumpSound
@onready var swordSwing = $SwordSwing
@export var node_path:NodePath
@export var speed = 100;
@export var acceleration = 750;
@export var deceleration = 1000;
var doubleDeceleration = deceleration*2;
var anim = AnimatedSprite2D;
var gravityApplied;
var normalGravity = 200;
var glideGravity = 50;
var fastFall = 400;
var jumpStrength = -150;
var canMove = Global.canMove;
var attackLength;
var groundYVelocity = 50;
const FLOOR_NORMAL = Vector2.UP;
var surface_normal = get_floor_normal();
var jumping = false;
var minJumpHeight = -50;
var justLeftLedge;
var wasOnFloor;




func _ready():
	self.show();
	wasOnFloor = is_on_floor();
	justLeftLedge = wasOnFloor and not is_on_floor() and velocity.y >= 0;
	print("Hello");
	anim = get_node("AnimatedSprite2D");
	anim.play("idle");

func _jump_gravity(delta):
	if Global.playerAlive:
		if (is_on_floor() or (justLeftLedge && coyoteJumpTimer.time_left > 0.0)):
			if Input.is_action_just_pressed("jump"):
				jumpSound.play();
				velocity.y += jumpStrength;
				jumping = true;
		if jumping && Input.is_action_just_released("jump"):
			if velocity.y < minJumpHeight:
				velocity.y = minJumpHeight;
			elif minJumpHeight > velocity.y && velocity.y > minJumpHeight:
				velocity.y = 0; 
		if is_on_floor() && not Input.is_action_just_pressed("jump"):
			jumping = false;
		
		if not is_on_floor():
			if velocity.y>0:
				if Input.is_action_pressed("jump"):
					velocity.y += delta * glideGravity;
					anim.play("glide");
				elif not Input.is_action_pressed("jump"):
					velocity.y += delta * fastFall;
					anim.play("fall");
			else:
				velocity.y += delta * normalGravity;
			

func _get_input(delta):
	var input_direction = Input.get_axis("ui_left", "ui_right");
	
	if Global.playerAlive && canMove:
		if velocity.x > 0 && input_direction < 0:
			velocity.x = move_toward(velocity.x, 0, doubleDeceleration*delta);
		elif velocity.x<0 && input_direction>0:
			velocity.x = move_toward(velocity.x, 0, doubleDeceleration*delta);
		elif (velocity.x<0 || velocity.x>0) && input_direction == 0:
			velocity.x = move_toward(velocity.x, 0, deceleration*delta);

		if canMove && velocity.x <= 0 && input_direction < 0:
			velocity.x = move_toward(velocity.x, speed * input_direction, acceleration * delta);
		elif canMove && velocity.x >= 0 && input_direction > 0:
			velocity.x = move_toward(velocity.x, speed * input_direction, acceleration * delta);
		
	if is_on_floor() && Input.is_action_just_pressed("attack") && canMove:
		canMove = false;
		swordSwing.play();
		velocity.x=0;
		anim.play("attack")
		await get_tree().create_timer(0.4).timeout
		canMove=true;

func _gotHit(delta):
	velocity.x = 0;
	velocity.y = 200;
	if Global.hitFromRight && Global.playerCanBeHit:
		velocity.x = -250;
		anim.play("hit")
		await get_tree().create_timer(0.2).timeout
		canMove = true;
		await get_tree().create_timer(0.5).timeout
		Global.playerGotHit = false;
	elif Global.hitFromLeft && Global.playerCanBeHit:
		velocity.x = 250;
		anim.play("hit")
		await get_tree().create_timer(0.5).timeout
		canMove = true;
		await get_tree().create_timer(0.5).timeout
		Global.playerGotHit = false;

func _animation():
	if canMove:
		#not moving
		if is_on_floor() && velocity.x == 0 && canMove:
			anim.play("idle")
		#walk and idle
		elif is_on_floor() && velocity.x != 0 && canMove:
			if Input.is_action_pressed("ui_right"):
				anim.flip_h = 0;
				anim.play("walk");
			if Input.is_action_pressed("ui_left"):
				anim.flip_h = -1;
				anim.play("walk");
			if Input.is_action_just_released("ui_right"):
				anim.flip_h = 0;
				anim.play("walk");
			if Input.is_action_just_released("ui_left"):
				anim.flip_h = -1;
				anim.play("walk");
		#jump
		#if is_on_floor() && Input.is_action_just_pressed("jump"):
			#anim.play("jump");
		if is_on_floor() && Input.is_action_just_pressed("jump") && !Global.playerCanBeHit:
			anim.play("jump");
		elif not is_on_floor() && not jumping && !Global.playerCanBeHit:
			anim.play("fall")
			
		if Input.is_action_pressed("ui_right"):
			anim.flip_h = 0;
		if Input.is_action_pressed("ui_left"):
			anim.flip_h = -1;
		

func _physics_process(delta):
	if Global.playerHealth != 0:
		$".".show();
		if Global.playerAlive && !Global.playerCanBeHit:
			_animation();
			_get_input(delta);
			_jump_gravity(delta);
		elif Global.playerAlive && Global.playerCanBeHit:
			velocity.x = 0;
			_gotHit(delta);
		move_and_slide()
	else: 
		$".".hide()
		_jump_gravity(delta);
		Global.playerAlive = false;
	Global.onFloor = is_on_floor();
