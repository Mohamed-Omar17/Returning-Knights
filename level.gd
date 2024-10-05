extends Node2D

class_name Enemy

var bgMusic = AudioStreamPlayer;
@onready var player = $Player;
@onready var FadeInOut = $Fade/CanvasLayer/AnimationPlayer
@onready var fade = $CanvasLayer/AnimationPlayer;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.show();
	Global.playerAlive = true;
	FadeInOut.play("fadeIn");
	bgMusic = get_node("AudioStreamPlayer");
	bgMusic.play();
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_bottomless_pit_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.playerAlive = false;
		FadeInOut.play("fadeOut");
		await get_tree().create_timer(1).timeout
		FadeInOut.play("fadeIn");
		body.position = Vector2(32, -20)
		Global.playerAlive=true;
func _physics_process(delta):
	if !Global.playerAlive:
		FadeInOut.play("fadeOut");
		await get_tree().create_timer(1).timeout
		$Player/CharacterBody2D.position = Vector2(32, -20)
		FadeInOut.play("fadeIn");
		$Player.show()
		Global.playerHealth = 3;
		Global.playerAlive=true;
