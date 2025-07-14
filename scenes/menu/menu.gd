extends CanvasLayer

@export var first_scene: GameManager.Scene
@export var bluppy_position: Vector2
@export var bluppy_direction: int

func _on_play_pressed() -> void:
	GameManager.change_scene(bluppy_position, bluppy_direction, first_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
