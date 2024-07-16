extends TileMap

func _on_hurt_area_body_entered(body):
	if body is Player:
		body.die()
