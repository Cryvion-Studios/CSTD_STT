extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

const GRAVITY = 1000
@export var SPEED : int = 300
@export var JUMP :int = -300
@export var JUMP_HORIZONTAL : int = 100

enum State { Idle, Run, Jump }

var current_state :State

func _ready():
	current_state = State.Idle

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(_delta : float):
	if is_on_floor():
		current_state = State.Idle

func player_run(_delta : float):
	
	if input_movement():
		velocity.x = input_movement() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if input_movement() != 0 and is_on_floor():
		current_state = State.Run
		animated_sprite_2d.flip_h = false if input_movement() > 0 else true

func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP
		current_state = State.Jump
	
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += input_movement() * JUMP_HORIZONTAL * delta

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")

func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction
