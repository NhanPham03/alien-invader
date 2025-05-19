extends Node2D


## References
@onready var player: Area2D = $Player
@onready var ui: MarginContainer = $CanvasLayer/UI
@onready var start_button: TextureButton = $CanvasLayer/CenterContainer/Start
@onready var game_over: TextureRect = $CanvasLayer/CenterContainer/GameOver

var enemy: PackedScene = preload("res://Scenes/enemy.tscn")


## Variables
var score: float = 0.0


## Built-in functions
func _ready() -> void:
	start_button.show()
	game_over.hide()


## User-defined functions
func spawn_enemies() -> void:
	for x in range(9):
		for y in range(3):
			var new_enemy = enemy.instantiate()
			var pos: Vector2 = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			
			add_child(new_enemy)
			new_enemy.start(pos)
			new_enemy.died.connect(_on_enemy_died)

func new_game() -> void:
	score = 0
	ui.update_score(score)
	player.start()
	spawn_enemies()


## Signal-related functions
func _on_enemy_died(value: float) -> void:
	score += value
	ui.update_score(score)

func _on_start_pressed() -> void:
	start_button.hide()
	new_game()

func _on_player_died() -> void:
	get_tree().call_group("enemies", "queue_free")
	game_over.show()
	await get_tree().create_timer(2).timeout
	game_over.hide()
	start_button.show()
