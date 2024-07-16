extends CharacterBody2D
class_name Bullet
var speed :int = 10000
var transition := 1

func _physics_process(delta):
	velocity.x = transition * speed * delta
	move_and_slide()

func set_pos(pos: Vector2):
	global_position = pos

func set_transition(trans: int):
	transition = trans


func _on_area_2d_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemy"):
		body.die()
		queue_free()

func _on_kill_timer_timeout():
	queue_free()
