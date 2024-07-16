extends Area2D
class_name TransitionDoor
@onready var player = %Player
@onready var end = $EndPos


signal transted


func _on_body_entered(body):
	player.global_position = end.global_position
	GameManager.load_position = end.global_position
