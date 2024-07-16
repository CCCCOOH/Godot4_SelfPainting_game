extends Node2D
@onready var music = $Music
@onready var enemies = preload("res://scenes/enemies.tscn")
@onready var player = %Player

func _ready():
	music.play()


func _on_player_born():
	var new_enemies = enemies.instantiate()
	new_enemies.position = GameManager.enemies_level_1
	var enemies_group = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies_group:
		enemy.queue_free()
	get_tree().root.get_node("Game").add_child(new_enemies)


func _on_dead_pressed():
	player.die() 
	print("按钮按下了")
