extends CharacterBody2D

var direction := 1
const SPEED = 1100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_left_2d = $RayCastLeft2D
@onready var ray_cast_right_2d = $RayCastRight2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	
	if ray_cast_left_2d.is_colliding():
		direction = 1
	elif ray_cast_right_2d.is_colliding():
		direction = -1
	if direction == 1:
		animated_sprite_2d.flip_h = true
	elif direction == -1:
		animated_sprite_2d.flip_h = false
	
	velocity.x = direction * SPEED * delta
	move_and_slide()


func die():
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()
