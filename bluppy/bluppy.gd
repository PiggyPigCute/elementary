extends CharacterBody2D

const WALK_SPEED: float = 300.0
const WALK_ACCEL: float = 6000.0
const DECELERATION: float = 3000.0
const DASH_SPEED: float = 1900.0
const JUMP_SPEED: float = -1100.0
const DASH_PARTICLES_GRAVITY: float = 100.0

@onready var head: Sprite2D = $Head
@onready var head_adnimation: AnimationPlayer = $HeadAnimation
@onready var body: Sprite2D = $Body
@onready var body_animation: AnimationPlayer = $BodyAnimation
@onready var dash_particles: GPUParticles2D = $DashParticles

var ambiant_velocity_x: float = 0
var direction: int = +1
var is_jumping: bool = false
var is_dashing: bool = false
var can_dash: bool = true
var is_in_rising_air: bool = false
var is_rise_dashing: bool = false

func _ready() -> void:
	direction = GameManager.bluppy_direction
	position = GameManager.bluppy_position
	velocity = Vector2(direction * WALK_SPEED, 0)
	set_display_direction()

func die() -> void:
	_ready()
	
	is_jumping = false
	is_dashing = false
	can_dash = false
	is_in_rising_air = false
	body_animation.play("idle")
	head.flip_h = false
	body.flip_h = false
	dash_particles.emitting = false


func _physics_process(delta: float) -> void:
	
	if not can_dash and not is_dashing and is_on_floor():
		can_dash = true
	
	if is_jumping and velocity.y >= 0:
		is_jumping = false
		if not is_dashing:
			body_animation.play("idle")
	
	if is_rise_dashing and velocity.y >= JUMP_SPEED:
		is_rise_dashing = false
		body_animation.play("idle")
		dash_particles.emitting = false
	
	if not is_on_floor():
		velocity.y += GameManager.GRAVITY * delta
	elif Input.is_action_pressed("jump"):
		is_jumping = true
		body_animation.play("jump")
		velocity.y = JUMP_SPEED
	
	var move_direction: int = Input.get_action_strength("right") - Input.get_action_strength("left")
	if move_direction == 0 or abs(velocity.x) > WALK_SPEED:
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0, DECELERATION*delta)
	else:
		if move_direction != direction:
			direction = move_direction
			set_display_direction()
		if move_direction * velocity.x < WALK_SPEED:
			velocity.x = move_toward(velocity.x, move_direction*WALK_SPEED, WALK_ACCEL*delta)
		
	if not is_dashing and can_dash and Input.is_action_pressed("dash"):
		if is_in_rising_air:
			velocity.y -= DASH_SPEED
			dash_particles.process_material.gravity = Vector3(0,-DASH_PARTICLES_GRAVITY,0)
			is_rise_dashing = true
		else:
			velocity.x = direction * DASH_SPEED
			dash_particles.process_material.gravity = Vector3(direction*DASH_PARTICLES_GRAVITY,0,0)
			is_dashing = true
		body_animation.play("dash")
		dash_particles.emitting = true
		can_dash = false
	
	
	move_and_slide()

	if is_dashing and (abs(velocity.x) <= WALK_SPEED or move_direction == -direction):
		is_dashing = false
		body_animation.play("idle")
		dash_particles.emitting = false
		if move_direction == -direction:
			velocity.x = direction * WALK_SPEED

	if Input.is_action_just_pressed("origin"):
		die()


func set_display_direction():
	head.flip_h = (direction == -1)
	body.flip_h = (direction == -1)
