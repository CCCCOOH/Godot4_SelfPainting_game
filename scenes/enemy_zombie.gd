extends CharacterBody2D
const SPEED = 5000.0
const JUMP_VELOCITY = -300.0
var direction := 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var left_ray_cast_2d = $LeftRayCast2D
@onready var right_ray_cast_2d = $RightRayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer



func _ready():
	animated_sprite_2d.play("run")
	add_to_group("enemy")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if left_ray_cast_2d.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	elif right_ray_cast_2d.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true

	velocity.x = direction * delta * SPEED
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY

func die():
	jump()
	animation_player.play("die")
