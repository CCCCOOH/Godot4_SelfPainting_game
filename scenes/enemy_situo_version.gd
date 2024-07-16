extends CharacterBody2D
class_name Enemy_situo
const SPEED := 5000.0
var speed := SPEED
const JUMP_VELOCITY = -200.0
@onready var right_ray_cast_2d = $RightRayCast2D
@onready var left_ray_cast_2d = $LeftRayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = delta * speed
		if right_ray_cast_2d.is_colliding():
			speed = -SPEED
			animated_sprite_2d.flip_h = true
		elif left_ray_cast_2d.is_colliding():
			speed = SPEED
			animated_sprite_2d.flip_h = false
		if speed:
			animated_sprite_2d.play("run")
	move_and_slide()

func die():
	animation_player.play("die")
	
