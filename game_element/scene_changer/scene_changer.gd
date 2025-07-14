extends Area2D

@export var destination: GameManager.Scene
@export var bluppy_position: Vector2
@export var bluppy_direction: int

func _on_body_entered(_body: Node2D) -> void:
	GameManager.change_scene(bluppy_position, bluppy_direction, destination)
