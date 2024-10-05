extends Control

const MAX_VALUE = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/ProgressBar.value = Global.playerHealth;

func _process(delta: float) -> void:
	if Global.playerCanBeHit:
		_changeHealth()
	if !Global.playerAlive:
		$CanvasLayer/ProgressBar.hide();
		$CanvasLayer/ProgressBar.value = MAX_VALUE;
		await get_tree().create_timer(1).timeout
		$CanvasLayer/ProgressBar.show();
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _changeHealth():
	$CanvasLayer/ProgressBar.value = Global.playerHealth;
