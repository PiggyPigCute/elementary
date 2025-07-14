extends Node

enum Scene { MENU, LEVEL_1, LEVEL_2, LEVEL_3 }
const SCENE: Dictionary = {
	Scene.MENU : preload("res://scenes/menu/menu.tscn"),
	Scene.LEVEL_1 : preload("res://scenes/lvl_01/level_01.tscn"),
	Scene.LEVEL_2 : preload("res://scenes/lvl_02/level_02.tscn"),
	Scene.LEVEL_3 : preload("res://scenes/lvl_03/level_03.tscn")
}

const GRAVITY: float = 3000.0

var bluppy_position: Vector2 = Vector2(0,0)
var bluppy_direction: int = 1
var previous_scene: Node

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_packed(SCENE[Scene.MENU])

func change_scene(position: Vector2, direction: int, scene_id: Scene) -> void:
	bluppy_position = position
	bluppy_direction = direction
	previous_scene = get_tree().current_scene
	call_deferred("actually_change_scene", scene_id)

func actually_change_scene(scene_id: Scene) -> void:
	get_tree().change_scene_to_packed(SCENE[scene_id])
