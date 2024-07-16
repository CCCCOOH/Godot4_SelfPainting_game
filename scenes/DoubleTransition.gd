extends Node2D
@onready var end_pos = $EndArea/EndPos
@onready var start_pos = $StartArea/StartPos



func _on_start_area_body_entered(body):
	body.position = end_pos.global_position
	GameManager.load_position = start_pos.global_position

func _on_end_area_body_entered(body):
	body.position = start_pos.global_position
