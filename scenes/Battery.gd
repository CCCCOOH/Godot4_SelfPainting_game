extends AnimatedSprite2D

@onready var player = %Player

func _process(delta):
	match player.bullet_num:
		0:
			play("zero")
		1:
			play("one")
		2:
			play("two")
		3:
			play("three")
		4:
			play("four")
