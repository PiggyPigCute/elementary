extends Camera2D

@export var x_min: float = 0
@export var x_max: float = 0
@export var y_min: float = 0
@export var y_max: float = 0

@onready var bluppy: CharacterBody2D = $"../Bluppy"

var x: float
var y: float

func _process(_delta: float) -> void:
	x = bluppy.position.x
	y = bluppy.position.y
	if x < x_min:
		position.x = x_min
	elif x > x_max:
		position.x = x_max
	else:
		position.x = x
	if y < y_min:
		position.y = y_min
	elif y > y_max:
		position.y = y_max
	else:
		position.y = y
