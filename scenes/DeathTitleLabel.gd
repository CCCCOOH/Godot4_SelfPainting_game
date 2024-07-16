extends Label
class_name DeathTitleLabel
@onready var animation_player = $AnimationPlayer

func _on_player_died():
	visible = true
	animation_player.play("DeathTitle")


func _on_player_born():
	visible = false
