extends CenterContainer

var bgMusic = AudioStreamPlayer;
@onready var menuMusic = $MainMenuTheme;
@onready var startGame = %StartGame;
@onready var fade = $CanvasLayer/AnimationPlayer;

func _ready():
	menuMusic.play();
	startGame.grab_focus();
	fade.play("fadeIn");

func _on_start_game_pressed() -> void:
	Global.playerHealth = 3;
	Global.doorOneOpened = false;
	fade.play("fadeOut");
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Level.tscn");


func _on_quit_game_pressed() -> void:
	get_tree().quit();
