extends CharacterBody2D
class_name Player
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var left_bullet_start = $LeftBulletStart
@onready var right_bullet_start = $RightBulletStart
@onready var bullet_flash_timer = $Bullet_flash_timer
@onready var shoot_gap_timer = $ShootGapTimer
@onready var jump_audio = $JumpAudio
@onready var hurt_audio = $HurtAudio
@onready var collision_shape_2d = $CollisionShape2D
@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var battery = $"../Display/Battery"
@onready var shoot_audio = $ShootAudio
@onready var dead_gap = $DeadGap
@onready var animation_player = $AnimationPlayer


signal died
signal born

const bulletMAX_SIZE = 4
const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var bullet_num := bulletMAX_SIZE
var is_alive := true
var can_shoot := true


enum  State {
	stand,
	move,
	jump,
	hurt,
	die
}
var state: State
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state = State.stand
	animated_sprite_2d.play("idle")
	
	
func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	match state:
		State.stand:
			animated_sprite_2d.play("idle")
			if direction:
				state = State.move
			if Input.is_action_pressed("jump"):
				velocity.y += JUMP_VELOCITY
				state = State.jump
				jump_audio.play()
			if Input.is_action_pressed("shoot"):
				shoot()
		State.move:
			if Input.is_action_pressed("shoot"):
				shoot()
			animated_sprite_2d.play("run")
			# 图像反转
			if direction == 1:
				animated_sprite_2d.flip_h = false
			elif direction == -1:
				animated_sprite_2d.flip_h = true
			
			# 检查移动
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				state = State.stand
			
			# 检查跳跃
			if Input.is_action_pressed("jump") and is_on_floor():
				jump_audio.play()
				velocity.y += JUMP_VELOCITY
				state = State.jump
		State.jump:
			if Input.is_action_pressed("shoot"):
				shoot()
			animated_sprite_2d.play("jump")
			# 图像反转
			if direction == 1:
				animated_sprite_2d.flip_h = false
			elif direction == -1:
				animated_sprite_2d.flip_h = true
			
			# 检查移动
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				state = State.stand
		State.hurt:
			pass
		State.die:
			pass
			
			
	if not is_on_floor():	# 玩家不在地面上
		velocity.y += gravity * delta
	move_and_slide()

func die():
	state = State.die
	animation_player.play("dead")
	
func die_emit():
	died.emit()
func born_emit():
	born.emit()
	

func shoot():
	if bullet_num > 0 and can_shoot:
		shoot_audio.play()
		can_shoot = false
		shoot_gap_timer.start()
		bullet_num -= 1
		var new_bullet:Bullet = bullet.instantiate()
		if animated_sprite_2d.flip_h == false:
			new_bullet.set_pos(right_bullet_start.global_position)
			new_bullet.set_transition(1)
		elif animated_sprite_2d.flip_h == true:
			new_bullet.set_pos(left_bullet_start.global_position)
			new_bullet.set_transition(-1) 
		get_tree().root.get_node("Game").add_child(new_bullet)
		
func _on_bullet_flash_timer_timeout():
	if bullet_num < bulletMAX_SIZE:
		bullet_num += 1

func _on_shoot_gap_timer_timeout():
	can_shoot = true

func _on_tread_enemy_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemy"):
		body.die()
		jump()

func jump():
	velocity.y = JUMP_VELOCITY


func _on_born():
	position = GameManager.load_position
	collision_shape_2d.disabled = false
	state = State.stand
	
